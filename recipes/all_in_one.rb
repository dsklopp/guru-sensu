#
# Cookbook Name:: guru-sensu
# Recipe:: all_in_one
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sensu::default"
include_recipe "guru-sensu::router"
include_recipe "guru-sensu::redis"
include_recipe "guru-sensu::rabbitmq"
include_recipe "guru-sensu::sensu-server"
include_recipe "guru-sensu::dashboard"
include_recipe "guru-sensu::sensu-client"
include_recipe "guru-sensu::metrics-collector"
include_recipe "guru-sensu::metrics-dashboard"

