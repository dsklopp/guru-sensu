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

include_recipe 'graphite::carbon'
include_recipe 'graphite::web'
include_recipe 'graphite::uwsgi'

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
    whisper_autoflush: false
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

graphite_service "cache:default"

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
