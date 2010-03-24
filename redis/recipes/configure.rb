include_recipe "deploy" # get the deployment attributes

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping redis::configure as application #{application} as it is not an Rails app")
    next
  end
  
  template "#{deploy[:deploy_to]}/shared/config/redis.yml" do
    source "redis.yml.erb"
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    variables(:host => node[:scalarium][:roles][:redis][:instances].first[:private_dns_name])
  end
end