#
# Cookbook Name:: guru-sensu
# Recipe:: consul
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#

include_recipe "consul::default"
include_recipe "consul::ui"
include_recipe "consul-template::default"
include_recipe "consul-template::service"
