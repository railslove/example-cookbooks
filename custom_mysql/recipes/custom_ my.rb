service "mysql" do
  service_name "mysql"
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/mysql/my.cnf" do
  source "my.cnf.erb"
  owner 'root'
  group 'root'
  notifies :restart, resources(:service => "mysql"), :immediately
end