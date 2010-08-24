group node[:postgresql9][:group]

user node[:postgresql9][:user] do
  gid node[:postgresql9][:group]
  home node[:postgresql9][:datadir]
end

directory node[:postgresql9][:datadir] do
  owner node[:postgresql9][:user]
  group node[:postgresql9][:group]
  action :create
end
