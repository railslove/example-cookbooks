node[:deploy].each do |application, deploy|
  template "/etc/monit/conf.d/resque_#{application}.monitrc" do
    source "resque.monit.erb"
    variables :deploy => deploy,
              :application => application
  end

  execute "monit reload && sleep 10 && monit restart -g resque_workers_#{application}"
end
