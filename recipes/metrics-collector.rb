#
# Cookbook Name:: guru-sensu
# Recipe:: redis
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#
include_recipe "guru-sensu::_common"

node.default.consul.servers=node.remotes.routers.ips
node.default.consul.service_mode='client'
include_recipe "guru-sensu::_consul"

include_recipe "runit"
include_recipe "nginx"

include_recipe 'graphite::carbon'
include_recipe 'graphite::web'
include_recipe 'graphite::uwsgi'

base_dir = "#{node['graphite']['base_dir']}"
storage_dir = node['graphite']['storage_dir']

graphite_carbon_cache "default" do
  config ({
    enable_logrotation: true,
    user: node.graphite.user,
    max_cache_size: "inf",
    max_updates_per_second: 500,
    max_creates_per_minute: 50,
    line_receiver_interface: '127.0.0.1',
    line_receiver_port: 2003,
    udp_receiver_port: 2003,
    pickle_receiver_port: 2004,
    enable_udp_listener: true,
    cache_query_port: "7002",
    cache_write_strategy: "sorted",
    use_flow_control: true,
    log_updates: false,
    log_cache_hits: false,
    whisper_autoflush: false,
    local_data_dir: "#{storage_dir}/whisper/"
  })
end

graphite_storage_schema "carbon" do
  config ({
    pattern: "^carbon\.",
    retentions: "60:90d"
  })
end

graphite_storage_schema "default_1min_for_1day" do
  config ({
    pattern: ".*",
    retentions: "60s:1d"
  })
end

directory "#{storage_dir}/log/webapp" do
  owner node['graphite']['user']
  group node['graphite']['group']
  recursive true
end

# Need to properly configure the uwsgi gateway via nginx.
template "/etc/nginx/sites-available/graphite" do
        source "graphite-nginx-conf.erb"
        owner 'www-data'
        group 'www-data'
        mode '0644'
        variables({
                :hostname => node['fqdn'],
                :address => "0.0.0.0",
                :port => node.graphite.webserver_port
        })
end

link "/etc/nginx/sites-enabled/graphite" do
        action :create
        to "/etc/nginx/sites-available/graphite"
end

graphite_web_config "#{base_dir}/webapp/graphite/local_settings.py" do
  config({
           secret_key: "a_very_secret_key_jeah!",
           time_zone: "America/Chicago",
           conf_dir: "#{base_dir}/conf",
           storage_dir: storage_dir,
           databases: {
             default: {
               # keys need to be upcase here
               NAME: "#{storage_dir}/graphite.db",
               ENGINE: "django.db.backends.sqlite3",
               USER: nil,
               PASSWORD: nil,
               HOST: nil,
               PORT: nil
             }
           }
         })
  notifies :restart, 'service[graphite-web]', :delayed
end

graphite_service "cache:default"
# I probably don't need to do this, but the graphite
# cookbook was written with the assumption you know all
# the components.
execute "python manage.py syncdb --noinput" do
  user node['graphite']['user']
  group node['graphite']['group']
  cwd "#{base_dir}/webapp/graphite"
  creates "#{base_dir}/storage/graphite.db"
  not_if { ::File.exists?("/#{base_dir}/storage/graphite.db")}
end

runit_service 'graphite-web' do
  cookbook 'graphite'
  default_logger true
end

consul_service_def 'graphite' do
  port 61702
  tags [ 'graphite' ]
  notifies :reload, 'service[consul]'
end

consul_service_def 'carbon' do
  port 61702
  tags [ 'carbon' ]
  notifies :reload, 'service[consul]'
end

consul_service_def 'whisper' do
  port 61702
  tags [ 'whisper' ]
  notifies :reload, 'service[consul]'
end
