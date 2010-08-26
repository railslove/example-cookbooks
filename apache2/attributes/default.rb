set[:apache][:timeout] = 60
set[:apache][:keepalive] = 'Off'
set[:apache][:prefork][:startservers] = 60
set[:apache][:prefork][:serverlimit] = 120
set[:apache][:prefork][:maxclients] = 120