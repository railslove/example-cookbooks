require 'digest/sha1'
require 'digest/md5'
srand
seed = "--#{rand(10000)}--#{Time.now}--"

default[:postgresql9] = {}
default[:postgresql9][:version] = '9.0beta4'
default[:postgresql9][:prefix] = '/usr/local/pgsql'
default[:postgresql9][:user] = "postgres"
default[:postgresql9][:group] = "postgres"
default[:postgresql9][:datadir] = '/vol/pgsql/data'
default[:postgresql9][:encoding] = 'UTF8'
default[:postgresql9][:temp_buffers] = '50MB'
default[:postgresql9][:shared_buffers] = '200MB'
default[:postgresql9][:port] = '5432'
default[:postgresql9][:max_connections] = 100
default[:postgresql9][:role] = 'scalarium'
default[:postgresql9][:password] = Digest::MD5.hexdigest(Digest::SHA1.hexdigest(seed)[0,8])
