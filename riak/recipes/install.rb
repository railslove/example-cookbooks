package "erlang"

user "riak" do
  shell "/bin/zsh"
end

local_riak_path = "/tmp/riak-#{node[:riak][:version]}"
local_riak_package = "#{local_riak_path}.tar.gz"

remote_file local_package do
  source node[:riak][:download_url]
end

execute "tar xvfz #{local_riak_package}" do
  cwd '/tmp'
end

execute "make all rel" do
  cwd local_riak_path
end

directory node[:riak][:prefix] do
  action :create
  owner "riak"
  mode "0755"
end

execute "mv #{local_riak_path}/* #{node[:riak][:prefix]}"
