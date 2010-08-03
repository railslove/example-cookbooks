default[:riak] = {}
default[:riak][:version_major] = '0'
default[:riak][:version_minor] = '12'
default[:riak][:version_patch] = '0'
default[:riak][:version] = "#{node[:riak][:version_major]}.#{node[:riak][:version_minor]}.#{node[:riak][:version_patch]}"
default[:riak][:download_url] = "http://downloads.basho.com/riak/riak-#{node[:riak][:version_major]}.#{node[:riak][:version_minor]}/riak-#{node[:riak][:version]}.tar.gz"
