#
# Cookbook Name:: guru-sensu
# Recipe:: sensu-client
#
# Copyright (C) 2015 Daniel Klopp
#
# All rights reserved - Do Not Redistribute
#

sensu_client node.name do
  address node.ipaddress
  subscriptions ["all"]
#  additional(:cluster => node.cluster)
end

include_recipe "sensu::client_service"
