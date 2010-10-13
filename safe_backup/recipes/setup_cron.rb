include_recipe "deploy::user"
include_recipe "deploy::directory"

node[:deploy].each do |application, deploy|
  cron "backup cronjob" do
    action  :create
    # Twice a day backups
    minute  "0"
    hour    '*/12'
    day     '*'
    month   '*'
    weekday '*'
    command "astrails-safe #{deploy[:deploy_to]}/current/config/server/backup.rb"
    user deploy[:user]
    path "/usr/bin:/usr/local/bin:/bin"
  end
end
