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


