include_recipe "redis::client" 

remote_file "/tmp/redis-#{node[:redis][:version]}" do
  source "http://redis.googlecode.com/files/redis-#{node[:redis][:version]}.tar.gz"
end

execute "tar xvfz /tmp/redis-#{node[:redis][:version]}" do
  cwd "/tmp"
end

execute "make" do
  cwd "/tmp/redis-#{node[:redis][:version]}"
end

user "redis" do
  shell "/bin/zsh"
  action :create
end

directory node[:redis][:datadir] do
  owner node[:redis][:user]
  group 'users'
  mode '0755'
end

ruby_block do
  block do
    %w{redis-server redis-cli redis-benchmark redis-check-aof redis-check-dump}.ech do |binary|
      FileUtils.install "/tmp/redis-#{node[:redis][:version]}/#{binary}",
                        "#{node[:redis][:prefix]}/bin", :mode => '0755'
      FileUtils.chown node[:redis][:user], 'users', "#{node[:redis][:prefix]}/bin/#{binary}"
    end
  end
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
  #notifies :restart, resources(:service => "redis-server"), :immediately
end

