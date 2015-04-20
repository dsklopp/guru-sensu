#
# Cookbook Name:: guru-sensu
# Recipe:: sensu-server
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#


include_recipe "sensu::api_service"
include_recipe "sensu::server_service"
