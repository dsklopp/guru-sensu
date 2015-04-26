#
# Cookbook Name:: guru-sensu
# Recipe:: _override_sensu_config
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#
include_recipe "sensu::default"

resources("sensu_base_config[#{node.name}]").action(:nothing)
#node.default.sensu.rabbitmq.port=61701
#node.default.sensu.redis.port=61702
#resources("sensu_base_config[#{node.name}]").action(:create)

template "sensu_config" do
  source 'sensu.json.erb'
  path '/etc/sensu/config.json'
  group 'sensu'
  owner 'root'
  mode '0644'
  variables({
    :redis_host => node.remotes.routers.ips.first,
    :redis_port => 61702,
    :rabbitmq_host => node.remotes.routers.ips.first,
    :rabbitmq_port => 61701,
    :api_host => node.sensu.api.host,
    :api_bind => node.sensu.api.bind,
    :api_port=> node.sensu.api.port
  })
end

