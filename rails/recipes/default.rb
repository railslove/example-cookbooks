package "rubygems"

Chef::Log.info("in a custom recipe that overrides a build-in one")

gem_package "rails" do
  version node[:rails][:version]
  retries 2
  action :install
end