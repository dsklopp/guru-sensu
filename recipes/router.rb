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
router=search(:node, "router").first
if router.nil?
  unless node.remotes.routers.ips.include?(node.ipaddress)
    node.default.remotes.routers.ips << node.ipaddress
  end
else
  unless node.remotes.routers.ips.include?(router.ipaddress)
    node.default.remotes.routers.ips << router.ipaddress
  end
end

node.default.consul.servers=node.remotes.routers.ips
node.default.consul.service_mode='cluster'
include_recipe "guru-sensu::_consul"


consul_service_def 'router' do
  port 22002
  tags [ 'router' ]
  notifies :reload, 'service[consul]'
end

include_recipe "haproxy::default"

cookbook_file "haproxy.cfg.ctmpl" do
  path "/etc/consul-templates/haproxy.cfg.ctmpl"
  source "haproxy.cfg.ctmpl"
  mode '0640'
  owner 'root'
  group 'root'
  notifies :reload, 'service[consul-template]', :delayed
end

consul_template_config 'haproxy' do
  templates [{
    source: '/etc/consul-templates/haproxy.cfg.ctmpl',
    destination: '/etc/haproxy/haproxy.cfg',
    command: 'service haproxy restart'
  }]
  notifies :reload, 'service[consul-template]', :delayed
end
