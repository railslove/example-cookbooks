service "sshd" do
  service_name "sshd"
  supports [:start, :stop, :restart]
  action :nothing
end

ruby_block "Install SSH host key" do
  block do
    system("cp -r /vol/config-files/ssh/* /etc/ssh/")
    system("chmod -R root /etc/ssh/")
  end
  
  only_if do
    File.exists?("/vol/config-files/ssh/ssh_host_rsa_key") && File.exists?("/vol/config-files/ssh/ssh_host_rsa_key.pub")
  end
  
  notifies :restart, resources(:service => "sshd")
end