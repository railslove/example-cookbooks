include_recipe "deploy::user"
include_recipe "deploy::source"
include_recipe 'sphinx::client'

node[:deploy].each do |application, deploy|
  directory "/var/log/sphinx" do
    action :create
    owner deploy[:user]
    group deploy[:group]
    mode "0755"
  end

  template "#{deploy[:deploy_to]}/shared/config/database.yml" do
    source "database.yml.erb"
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:database => deploy[:database], :environment => deploy[:rails_env])
    cookbook "rails" 

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/database.yml")
    end
  end

  execute "rake thinking_sphinx:configure" do
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
    environment 'RAILS_ENV' => deploy[:rails_env]
  end

  execute "rake thinking_sphinx:restart" do
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
    environment 'RAILS_ENV' => deploy[:rails_env]
  end

  execute 'rake thinking_sphinx:index' do
    cwd "#{deploy[:deploy_to]}/current"
    user deploy[:user]
    environment 'RAILS_ENV' => deploy[:rails_env]
  end

  cron "sphinx reindex cronjob" do
    action  :create
    minute  "*/#{node[:sphinx][:cron_interval]}"
    hour    '*'
    day     '*'
    month   '*'
    weekday '*'
    command "cd #{deploy[:deploy_to]}/current && RAILS_ENV=#{deploy[:rails_env]} rake thinking_sphinx:index"
    user deploy[:user]
  end
end
