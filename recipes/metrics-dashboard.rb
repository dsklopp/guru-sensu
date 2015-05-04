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

include_recipe "grafana::default"


node.default.grafana.graphite_server=query_consul("graphite")
if node.default.grafana.webserver == ''
  node.default.grafana.datasources['elasticsearch']['url'] =
    'window.location.protocol+"//"+window.location.hostname+":"+window.location.port+"/_es"'
  web_app 'grafana' do
    template 'grafana.conf.erb'
    server_name node.hostname
    server_aliases [node.fqdn, '*']
    server_port node.grafana.webserver_port
    docroot node.grafana.install_dir
  end
end

consul_service_def 'grafana' do
  port 61702
  tags [ 'grafana' ]
  notifies :reload, 'service[consul]'
end

