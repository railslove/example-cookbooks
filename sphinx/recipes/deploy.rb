include_recipe "deploy::user"

node[:deploy].each do |application, deploy|
  directory "#{deploy[:deploy_to]}/shared/cached-copy" do
    recursive true
    action :delete
  end

  deploy deploy[:deploy_to] do
    repository deploy[:scm][:repository]
    user deploy[:user]
    revision deploy[:scm][:revision]
    migrate false
    environment "RAILS_ENV" => deploy[:rails_env], "RUBYOPT" => ""
    symlink_before_migrate deploy[:symlink_before_migrate]
    action deploy[:action]
    case deploy[:scm][:scm_type].to_s
    when 'git'
      scm_provider Chef::Provider::Git
      enable_submodules deploy[:enable_submodules]
      shallow_clone true
    when 'svn'
      scm_provider Chef::Provider::Subversion
      svn_username deploy[:scm][:user]
      svn_password deploy[:scm][:password]
    else
      raise "unsupported SCM type #{deploy[:scm][:scm_type].inspect}"
    end
    before_migrate lambda{}
    after_restart lambda{}
    before_symlink lambda{}
    before_restart lambda{}
  end

  execute "fix access rights on deployment directory" do
    command "chmod o-w #{deploy[:deploy_to]}"
    action :run
  end
end

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
