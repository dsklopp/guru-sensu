#
# Cookbook Name:: guru-sensu
# Recipe:: _common
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#

begin
  if defined(node.remotes.routers.ips)
  end
rescue NoMethodError
  routers=search(:node, "recipes:router")
  ips=[]
  routers.each do |router|
    ips << router.ip
  end
  node.default.remotes.routers.ips=ips
end

include_recipe "sensu::default"

# Set some dynamic attributes
node.default.sensu.redis.host=node.remotes.routers.ips.first
node.default.sensu.rabbitmq.host=node.remotes.routers.ips.first

include_recipe "guru-sensu::_consul"
