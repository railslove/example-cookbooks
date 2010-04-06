service "sshd" do
  service_name "sshd"
  supports [:start, :stop, :restart]
  action :nothing
end

ruby_block do
  block do
    system("mv /vol/config-files/ssh/* /etc/ssh/")
  end
  
  only_if do
    File.exists?("/vol/config-files/ssh/ssh_host_rsa_key") && File.exists?("/vol/config-files/ssh/ssh_host_rsa_key.pub")
  end
  
  notifies :restart, resources(:service => "sshd")
end