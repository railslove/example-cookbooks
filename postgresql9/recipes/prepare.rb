group node[:postgresql9][:group]

user node[:postgresql9][:user] do
  gid node[:postgresql9][:group]
end

directory node[:postgresql9][:datadir] do
  owner node[:postgresql9][:user]
  group node[:postgresql9][:group]
  action :create
end
