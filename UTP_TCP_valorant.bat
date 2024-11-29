@echo off
:: Script to open required ports for VALORANT game and related services

:: Open VALORANT Game Client ports (UDP 7000-8000, 8180-8181)
netsh advfirewall firewall add rule name="VALORANT Game Client UDP 7000-8000" protocol=UDP dir=in localport=7000-8000 action=allow
netsh advfirewall firewall add rule name="VALORANT Game Client UDP 8180-8181" protocol=UDP dir=in localport=8180-8181 action=allow

:: Open Voice Chat ports (TCP, 50 ports in range 1024-65000, example 61000-61050)
netsh advfirewall firewall add rule name="Voice Chat TCP 61000-61050" protocol=TCP dir=in localport=61000-61050 action=allow

:: Open Installer and Master ports (TCP 8393-8400)
netsh advfirewall firewall add rule name="Installer and Master TCP 8393-8400" protocol=TCP dir=in localport=8393-8400 action=allow

:: Open PVP.Net ports (TCP 2099, 5223, 5222)
netsh advfirewall firewall add rule name="PVP.Net TCP 2099" protocol=TCP dir=in localport=2099 action=allow
netsh advfirewall firewall add rule name="PVP.Net TCP 5223" protocol=TCP dir=in localport=5223 action=allow
netsh advfirewall firewall add rule name="PVP.Net TCP 5222" protocol=TCP dir=in localport=5222 action=allow

:: Open HTTP Connections port (TCP 80)
netsh advfirewall firewall add rule name="HTTP Connections TCP 80" protocol=TCP dir=in localport=80 action=allow

:: Open HTTPS Connections port (TCP 443)
netsh advfirewall firewall add rule name="HTTPS Connections TCP 443" protocol=TCP dir=in localport=443 action=allow

:: Open Spectator Mode ports (TCP/UDP 8088)
netsh advfirewall firewall add rule name="Spectator Mode TCP/UDP 8088" protocol=TCP dir=in localport=8088 action=allow
netsh advfirewall firewall add rule name="Spectator Mode UDP 8088" protocol=UDP dir=in localport=8088 action=allow

:: Open VALORANT NA and EU voice ports (UDP 27016-27024)
netsh advfirewall firewall add rule name="VALORANT NA and EU voice UDP 27016-27024" protocol=UDP dir=in localport=27016-27024 action=allow

:: Open VALORANT AP and SE voice ports (UDP 54000-54012)
netsh advfirewall firewall add rule name="VALORANT AP and SE voice UDP 54000-54012" protocol=UDP dir=in localport=54000-54012 action=allow

echo Firewall rules have been added successfully!
pause
