#
# Cookbook Name:: guru-sensu
# Recipe:: rabbitmq
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#
include_recipe "guru-sensu::_common"

node.default.consul.servers=node.remotes.routers.ips
node.default.consul.service_mode='client'
include_recipe "guru-sensu::_consul"

include_recipe "sensu::rabbitmq"

consul_service_def 'rabbitmq' do
  port 61701
  tags [ 'rabbitmq' ]
  notifies :reload, 'service[consul]'
end
