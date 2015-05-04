# A lot of variables here are set to ensure the latest and greatest
# Source builds are done because, well, most distributions have old packages

default.sensu.use_ssl=false
#if node.platform == "redhat" 
  default.sensu.init_style="sysv"
#else
#  default.sensu.init_style="runit"
#end

# Sometimes sensu is slow to stop
default.sensu.service_max_wait=10

# This gets run before apt-get, even after setting
# apt-get to run at compile time
override['build-essential']['compile_time']=false

default.consul.datacenter='sensu'
default.consul.domain='.sensu.consul'
default.consul.log_level='debug'
#default.consul.service_mode='cluster'
#default.consul.advertise_addr='0.0.0.0'
if default['guru-sensu'].test_kitchen_mode
  default.consul.bind_interface='eth1'
  default.consul.advertise_interface='eth1'
  default.grafana.webserver_listen='192.168.12.41'
end
default.grafana.webserver_port=8081

# These two are identical
default.graphite.webserver_port=8082
default.grafana.graphite_port=8082

default.graphite.user='www-data'
default.graphite.group='ww-data'

default.consul.bootstrap_expect=1
default.consul.serve_ui=true

default.sensu.consul_template.url='https://github.com/hashicorp/consul-template/releases/download/v0.8.0/consul-template_0.8.0_linux_amd64.tar.gz'
