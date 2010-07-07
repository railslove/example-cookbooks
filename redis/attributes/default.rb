default[:redis] = {}
default[:redis][:bind_address] = ipaddress
default[:redis][:port] = 6379
default[:redis][:timeout] = 300
default[:redis][:version] = '2.0.0-rc2'
default[:redis][:prefix] = '/usr/local'
default[:redis][:user] = 'redis'
default[:redis][:datadir] = '/var/lib/redis'
