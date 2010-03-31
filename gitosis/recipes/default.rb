
package "gitosis"

user "git" do
  comment "Gitosis/Git user"
  gid "users"
  home "/srv/gitosis/"
end

directory "/srv/gitosis" do
  action :create
  owner "git"
  group "users"
end