package "openjdk-6-dbg"
package "openjdk-6-jre"
package "openjdk-6-jdk"
package "openjdk-6-jre-lib"
package "openjdk-6-jre-headless"

user node[:sunspot_solr][:user] do
  gid 'users'
  home '/var/lib/solr'
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
end

directory node[:sunspot_solr][:conf] do
  action :create
  owner node[:sunspot_solr][:user]
  group 'users'
end

execute 'start solr service' do
  command "sunspot-solr start -- -p #{node[:sunspot_solr][:port]} --pid-dir=#{node[:sunspot_solr][:pids]} -d #{node[:sunspot_solr][:home]}"
  action :run
end
