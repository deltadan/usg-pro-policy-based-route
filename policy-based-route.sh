#show interfaces used to find IP addresses on the USG PRO

deltadan@DELTAV-FW:~$ show interfaces
Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down
Interface    IP Address                        S/L  Description
---------    ----------                        ---  -----------
eth0         192.168.1.1/24                    u/u  LAN
eth1         -                                 u/u  LAN2
eth1.2       192.168.2.1/24                    u/u
eth2         47.XX.XX.197/24                 u/u  WAN
eth3         70.XX.XX.85/22                   u/u  WAN2
lo           127.0.0.1/8                       u/u
             ::1/128
# Use the following website to figure out the ISP router
Find the gateway based on the IP of the WAN Interface using this calculator:
70.XX.XX.85/22
https://www.xarg.org/tools/subnet-calculator

# The addresses that we need for our policy based route command
LAN1 (eth1-vlan2) network: 192.168.2.0/24
WAN2 gateway:  70.XX.XX.1

# Command to be run on the USG PRO via SSH - puts into running config
# Must use the config.gateway.json file on the controller to be persist config
configure
set protocols static table 5 route 0.0.0.0/0 next-hop 70.XX.XX.1
set firewall modify LOAD_BALANCE rule 2640 action modify
set firewall modify LOAD_BALANCE rule 2640 modify table 5
set firewall modify LOAD_BALANCE rule 2640 source address 192.168.2.0/24
set firewall modify LOAD_BALANCE rule 2640 protocol all
commit;exit