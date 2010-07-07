include_recipe "redis::client" 

remote_file "/tmp/redis-#{node[:redis][:version]}" do
  source "http://redis.googlecode.com/files/redis-#{node[:redis][:version]}.tar.gz"
end

execute "tar xvfz /tmp/redis-#{node[:redis][:version]}" do
  cwd "/tmp"
end

execute "make && make install" do
  cwd "/tmp/redis-#{node[:redis][:version]}"
end

#service "redis-server" do
#  service_name "redis-server"
#
#  supports :status => false, :restart => true, :reload => false, "force-reload" => true
#  action :enable
#end


template "/etc/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "redis-server"), :immediately
end

