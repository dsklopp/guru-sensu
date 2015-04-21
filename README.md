# guru-sensu-cookbook

Configuration cookbook for Sensu.  This cookbook is meant for deploying a Sensu Server and Client with all the bells and whistles normally attributed of such an installation.

I would like to thank Sean Porter's chef-monitor cookbook for much of the inspiration for this variant.  This cookbook is a complete rewrite that better fits deployments.  Having said that, the bulk of this cookbook is tightly coupled with Sean's original chef-sensu cookbook.

## Architecture
Sensu is a naturally distributed application.  This cookbook was designed to reflect that design.

Sensu's components are Redis, RabbitMQ, Sensu-Server + Sensu-Api.  When setting up high availability or greater levels of performance, the easiest way to achieve this is by separating the components onto their own clusters.  For example, a Redis HA cluster, a RabbitMQ cluster, a Sensu cluster.  These are interconnected with a load balancing abstraction which I call router.  The router is just a set of haproxy load balancers.  Redis, RabbitMQ and Sensu-Server communicate through this abstraction.

There is a complexity involved though that is not readily fixed.  This complexity is how to abstract out the router with a VIP.  You would think this is simple, but it isn't.  In practice, this requires fancy configuration with load balancers in AWS.  Or it requires setting up KeepaliveD, which, incidentally, has trouble working in any cloud environment as multicast is generally restricted (AWS, I'm looking at you!)  Your best bet is DNS with very short TTL.  Place that on your router cluster.  Anything else is generally too complicated.

### Limitations
Thanks to limitations of test-kitchen, what is tested locally and what is deployed to production are not the same.  Test-kitchen has strangely decided not to adapt to modern, distributed services dependent on other nodes for information.  Pretty much all modern infrastructure.  Despite this, test-kitchen is still one of the best tools out there (though handicapped).  So to make all this work, there are a number of overrided attributes needed to make this work properly.  In production, this is normally achieved with a Chef search.



## Supported Platforms

 * Ubuntu 12.04
 * Ubuntu 14.04
 * Centos 6.05

## Attributes

None listed at this time

## Usage

This cookbook has several different outputs.  One of them is configuring a Sensu Server and/or Sensu Client.  The other is deploying RPM packages.

By default this cookbook builds from source.  It does so because many existing repositories have old packages.  You can also use this cookbook to produce packages for later use.

### guru-sensu::default
Does nothing except pull in dependencies.

### guru-sensu::dashboard
Deploys the Sensu Dashboard.  By default it is uchiwa.

### guru-sensu::server

### guru-sensu::redis
For deploying the Redis Database.

### guru-sensu::router
For deploying the router.

### guru-sensu::rabbitmq
For deploying RabbitMQ

### guru-sensu::sensu-server
For deploying the Sensu-server and Sensu-api


### guru-sensu::sensu-client
For deploying the Sensu-client

### guru-sensu::all_in_one
Many times, the best solution is several sensu servers that can be load balanced.  Use this one to deploy a Sensu server on a single node.

### guru-sensu::_common
Don't directly use this.

### guru_sensu::_consul
Don't directly use this.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
