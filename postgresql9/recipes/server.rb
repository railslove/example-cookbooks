# Temporary, until we updated our agents to have a default
File.umask(022)
include_recipe "postgresql9::prepare"

local_unpacked = "/tmp/postgresql-#{node[:postgresql9][:version]}"
local_package = "/tmp/postgresql-#{node[:postgresql9][:version]}.tar.bz2"

package "libreadline-dev"

remote_file local_package do
  source "http://ftp3.de.postgresql.org/pub/Mirrors/ftp.postgresql.org/source/v#{node[:postgresql9][:version]}/postgresql-#{node[:postgresql9][:version]}.tar.bz2"
end

execute "tar xvfj #{local_package}" do
  cwd "/tmp"
  umask 022
end

execute "./configure --prefix=#{node[:postgresql9][:prefix]} && make && make install" do
  cwd local_unpacked
  umask 022
end

execute "#{node[:postgresql9][:prefix]}/bin/initdb -D #{node[:postgresql9][:datadir]}" do
  umask 022
  user node[:postgresql9][:user]
end

template "/etc/init.d/postgresql" do
  source "postgresql.init.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "postgresql" do
  action [:enable, :start]
  supports :restart => true, :start => true
end
