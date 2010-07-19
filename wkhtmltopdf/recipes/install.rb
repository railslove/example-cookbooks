file = "wkhtmltopdf-#{node[:wkhtmltopdf][:version]}-static-#{node[:wkhtmltopdf][:arch]}.tar.bz2"

remote_file "/tmp/#{file}" do
  source "http://wkhtmltopdf.googlecode.com/files/#{file}"
  owner 'root'
  group 'root'
  not_if do
    File.exist?('/usr/local/bin/wkhtmltopdf')
  end
end

execute "tar xfvj /tmp/#{file}" do
  cwd "/tmp"
  not_if do
    File.exist?('/usr/local/bin/wkhtmltopdf')
  end
end

execute "mv /tmp/wkhtmltopdf-#{node[:wkhtmltopdf][:arch]} /usr/local/bin" do
  creates '/usr/local/bin/wkhtmltopdf'
end
