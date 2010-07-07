package "openjdk-6-dbg"
package "openjdk-6-jre"
package "openjdk-6-jdk"
package "openjdk-6-jre-lib"
package "openjdk-6-jre-headless"

user node[:sunspot_solr][:user] do
  gid 'users'
  home '/var/lib/solr'
  shell '/bin/zsh'
  action :create
end

gem_package "sunspot" do
  action :install
  retries 2
end

directory node[:sunspot_solr][:home] do
  action :create
  owner node[:sunspot_solr][:user]
  group 'users'
  mode '0755'
end

directory node[:sunspot_solr][:conf] do
  action :create
  owner node[:sunspot_solr][:user]
  group 'users'
  mode '0755'
end

directory node[:sunspot_solr][:log] do
  action :create
  owner node[:sunspot_solr][:user]
  group 'users'
  mode '0755'
end

execute 'start solr service' do
  command "sunspot-solr start -- -p #{node[:sunspot_solr][:port]} --pid-dir=#{node[:sunspot_solr][:pids]} -d #{node[:sunspot_solr][:home]} --min-memory=#{node[:sunspot_solr][:min_memory]} --max-memory=#{node[:sunspot_solr][:max_memory]} --log-file=#{node[:sunspot_solr][:log]}/solr.log --log-level=#{node[:sunspot_solr][:log_level]}"
  action :run
  user node[:sunspot_solr][:user]
  group 'users'
end
