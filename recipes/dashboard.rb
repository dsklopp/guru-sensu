#
# Cookbook Name:: guru-sensu
# Recipe:: dashboard
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#

include_recipe "guru-sensu::_common"

node.default.consul.servers=node.remotes.routers.ips
node.default.consul.service_mode='client'
include_recipe "guru-sensu::_consul"


include_recipe "uchiwa"
consul_service_def 'uchiwa' do
  port 3000
  tags [ 'uchiwa' ]
  notifies :reload, 'service[consul]'
end
