node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping sphinx::client as application #{application} is not a Rails application")
    next
  end
 
  directory "#{deploy[:deploy_to]}/current/config/thinkingsphinx" do
    action :create
    owner deploy[:user]
    group deploy[:group]
    mode "0755"
  end

  template "#{deploy[:deploy_to]}/current/config/sphinx.yml" do
    source "sphinx.yml.erb"
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    
    only_if do
      File.directory?("#{deploy[:deploy_to]}/current")
    end

    host = node[:scalarium][:roles][:sphinx][:instances][node[:scalarium][:roles][:sphinx][:instances].keys.first]['private_dns_name']

    variables :application => application,
              :deploy => deploy,
              :host => host
  end

end
