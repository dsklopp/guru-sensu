#
# Cookbook Name:: guru-sensu
# Recipe:: redis
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#
include_recipe "guru-sensu::_common"

include_recipe "sensu::redis"

