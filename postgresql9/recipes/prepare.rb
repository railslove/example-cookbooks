group node[:postgresql9][:group]

user node[:postgresql9][:user] do
  gid node[:postgresql9][:group]
end
