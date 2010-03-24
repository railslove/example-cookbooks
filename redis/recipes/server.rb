include_recipe "redis::client" 
include_attribute "redis" # to load attributes

package "redis-server" do
  action :install
end

service "redis-server" do
  service_name "redis-server"

  supports :status => false, :restart => true, :reload => false, "force-reload" => true
  action :enable
end


template "/etc/redis/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "redis-server"), :immediately
end

