#
# Cookbook Name:: guru-sensu
# Recipe:: router
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#

# Find all router IPs and include self in that list

include_recipe "guru-sensu::_common"
unless node.remotes.routers.ips.include?(node.ipaddress)
  node.default.remotes.routers.ips << node.ipaddress
end

include_recipe "haproxy"

haproxy_lb 'rabbitmq' do
  bind '0.0.0.0:5672'
  mode 'tcp'
  "rabbitmq 192.168.12.42:5672 check inter 10s rise 2 fall 3"
  params({
    'maxconn' => 20000,
    'balance' => 'roundrobin'
  })
end

haproxy_lb 'redis' do
  bind '0.0.0.0:5672'
  mode 'tcp'
  "redis 192.168.12.41:6379 check inter 10s rise 2 fall 3"
  params({
    'maxconn' => 20000,
    'balance' => 'roundrobin'
  })
end

haproxy_lb 'uchiwa' do
  bind '0.0.0.0:80'
  mode 'tcp'
  "redis 192.168.12.43:3000 check inter 10s rise 2 fall 3"
  params({
    'maxconn' => 20000,
    'balance' => 'roundrobin'
  })
end
