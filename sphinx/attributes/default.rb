default[:sphinx] = {}
default[:sphinx][:version] = '0.9.9'
default[:sphinx][:package_name] = "sphinx-#{node[:sphinx][:version]}.tar.gz"
default[:sphinx][:memory_limit] = "256M"
default[:sphinx][:cron_interval] = 10
default[:sphinx][:port] = 9312
