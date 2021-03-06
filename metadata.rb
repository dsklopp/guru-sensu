name             'guru-sensu'
maintainer       'Daniel Klopp'
maintainer_email 'dsklopp@gmail.com'
license          'All rights reserved'
description      'Installs/Configures guru-sensu'
long_description 'Installs/Configures guru-sensu'
version          '0.1.1'

%w[
  ubuntu
  debian
  centos
  redhat
  fedora
].each do |os|
  supports os
end

depends "apt"
depends "sensu", "= 2.9.0"
depends "consul", "= 0.9.1"
depends "sudo"
depends "uchiwa"
depends "haproxy"
depends 'consul-template'
depends 'graphite'
depends 'grafana'
