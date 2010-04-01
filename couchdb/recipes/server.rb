package "couchdb"

service "couchdb" do
  service_name "couchdb"
  supports [:restart, :status]
  action [:enable, :start]
end

%w{db views log}.each do |dir|
  directory "/mnt/couchdb/#{dir}" do
    owner "couchdb"
    group "couchdb"
    mode "0755"
    action :create
    not_if "test -d /mnt/couchdb/#{dir}"
    recursive true
  end
end

template "/etc/couchdb/local.d/scalarium.ini" do
  source "scalarium.ini.erb"
  owner "couchdb"
  group "couchdb"
  mode "0644"
  notifies :restart, resources(:service => "couchdb"), :immediately
end