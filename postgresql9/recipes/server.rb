# Temporary, until we updated our agents to have a default
File.umask(022)
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

