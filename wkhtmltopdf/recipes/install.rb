file = "wkhtmltopdf-#{node[:wkhtmltopdf][:version]}-static-#{node[:wkhtmltopdf][:arch]}.tar.bz2"

remote_file "/tmp/#{file}" do
  source "http://wkhtmltopdf.googlecode.com/files/#{file}"
  owner 'root'
  group 'root'
end

execute "tar xfvj /tmp/#{file}" do
  cwd "/tmp"
end

execute "mv /tmp/wkhtmltopdf-#{node[:wkhtmltopdf][:version]} /usr/local/bin" do
  create '/usr/local/bin/wkhtmltopdf'
end
