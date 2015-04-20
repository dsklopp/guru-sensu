#
# Cookbook Name:: guru-sensu
# Recipe:: all_in_one
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#
# Default recipe, include it to bring in the dependencies
# Otherwise it does nothing

include_recipe "sensu::default"
include_recipe "guru-sensu::router"
include_recipe "guru-sensu::redis"
include_recipe "guru-sensu::rabbitmq"
include_recipe "guru-sensu::sensu-server"
include_recipe "guru-sensu::sensu-client"

