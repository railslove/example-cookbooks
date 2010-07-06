package "libmysql++-dev" do
  action :install
end

directory "/tmp/sphinx_install" do
  mode "0755"
  action :create
end

remote_file "/tmp/sphinx_install/#{node[:sphinx][:package_name]}" do
  source "http://www.sphinxsearch.com/downloads/#{node[:sphinx][:package_name]}"
  mode "0644"
  action :create_if_missing
end

execute "untar sphinx archive" do
  command "tar xvfz #{node[:sphinx][:package_name]}"
  cwd "/tmp/sphinx_install"
end

execute "./configure --with-mysql && make && make install" do
  cwd "/tmp/sphinx_install/sphinx-#{node[:sphinx][:version]}"
end
