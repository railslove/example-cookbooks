execute "stop couchdb" do
  command "kill `ps ax | grep couch | grep -v grep | awk '{print $1}'` && echo 0"
  action :run
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
end

service "couchdb" do
  service_name "couchdb"
  supports [:start, :status, :restart]
  action :start
end
