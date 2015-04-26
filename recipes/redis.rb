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
include_recipe "sensu::redis"

consul_service_def 'redis' do
  port 61702
  tags [ 'redis' ]
  notifies :reload, 'service[consul]'
end

