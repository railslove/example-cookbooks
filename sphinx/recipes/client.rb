node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping sphinx::client as application #{application} is not a Rails application")
    next
  end
 
  redis_server = node[:scalarium][:roles][:mysql][:instances].keys.first
  
  template "#{deploy[:deploy_to]}/current/config/sphinx.yml" do
    source "sphinx.yml.erb"
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    
    if deploy[:stack][:needs_reload]
      notifies :run, resources(:execute => "restart Rails app #{application}")
    end
    
    only_if do
      File.directory?("#{deploy[:deploy_to]}/current")
    end

    variables :application => application,
              :deploy => deploy,
              :memory_limit => node[:sphinx][:memory_limit]
  end

  execute "rake thinking_sphinx:configure" do
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
    command "cd /data/#{application}/current && RAILS_ENV=#{deploy[:rails_env]} rake thinking_sphinx:index"
    user deploy[:user]
  end
  
end
