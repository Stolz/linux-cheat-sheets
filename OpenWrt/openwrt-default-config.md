Esta es la configuración que viene por defecto en [OpenWrt](http://kamikaze.openwrt.org/) KAMIKAZE 8.09

	root@OpenWrt:# cd /etc/config/
	root@OpenWrt:/etc/config# for i in `ls`; do echo ==============$i============== && cat $i; done
	==============dhcp==============

	config 'dnsmasq'
			option 'domainneeded' '1'
			option 'boguspriv' '1'
			option 'filterwin2k' '0'
			option 'localise_queries' '1'
			option 'local' '/lan/'
			option 'domain' 'lan'
			option 'expandhosts' '1'
			option 'nonegcache' '0'
			option 'authoritative' '1'
			option 'readethers' '1'
			option 'leasefile' '/tmp/dhcp.leases'
			option 'resolvfile' '/tmp/resolv.conf.auto'

	config 'dhcp' 'lan'
			option 'interface' 'lan'
			option 'ignore' '1'

	config 'dhcp' 'wan'
			option 'interface' 'wan'
			option 'ignore' '1'

	==============dropbear==============
	config dropbear
			option PasswordAuth 'on'
			option Port         '22'
	==============firewall==============
	config defaults
			option syn_flood        1
			option input            ACCEPT
			option output           ACCEPT
			option forward          REJECT

	config zone
			option name             lan
			option input    ACCEPT
			option output   ACCEPT
			option forward  REJECT

	config zone
			option name             wan
			option input    REJECT
			option output   ACCEPT
			option forward  REJECT
			option masq             1

	config forwarding
			option src      lan
			option dest     wan
			option mtu_fix  1

	# We need to accept udp packets on port 68,
	# see https://dev.openwrt.org/ticket/4108
	config rule
			option src              wan
			option proto            udp
			option dest_port        68
			option target           ACCEPT

	# include a file with users custom iptables rules
	config include
			option path /etc/firewall.user


	### EXAMPLE CONFIG SECTIONS
	# do not allow a specific ip to access wan
	#config rule
	#       option src              lan
	#       option src_ip   192.168.45.2
	#       option dest             wan
	#       option proto    tcp
	#       option target   REJECT

	# block a specific mac on wan
	#config rule
	#       option dest             wan
	#       option src_mac  00:11:22:33:44:66
	#       option target   REJECT

	# block incoming ICMP traffic on a zone
	#config rule
	#       option src              lan
	#       option proto    ICMP
	#       option target   DROP

	# port redirect port coming in on wan to lan
	#config redirect
	#       option src                      wan
	#       option src_dport        80
	#       option dest                     lan
	#       option dest_ip          192.168.16.235
	#       option dest_port        80
	#       option proto            tcp


	### FULL CONFIG SECTIONS
	#config rule
	#       option src              lan
	#       option src_ip   192.168.45.2
	#       option src_mac  00:11:22:33:44:55
	#       option src_port 80
	#       option dest             wan
	#       option dest_ip  194.25.2.129
	#       option dest_port        120
	#       option proto    tcp
	#       option target   REJECT

	#config redirect
	#       option src              lan
	#       option src_ip   192.168.45.2
	#       option src_mac  00:11:22:33:44:55
	#       option src_port         1024
	#       option src_dport        80
	#       option dest_ip  194.25.2.129
	#       option dest_port        120
	#       option proto    tcp
	==============fstab==============
	config mount
			option target   /home
			option device   /dev/sda1
			option fstype   ext3
			option options  rw,sync
			option enabled  0

	config swap
			option device   /dev/sda2
			option enabled  0
	==============httpd==============

	config 'httpd'
			option 'port' '80'
			option 'home' '/www'

	==============luci==============

	config 'core' 'main'
			option 'lang' 'auto'
			option 'mediaurlbase' '/luci-static/openwrt.org'
			option 'resourcebase' '/luci-static/resources'

	config 'extern' 'flash_keep'
			option 'uci' '/etc/config/'
			option 'dropbear' '/etc/dropbear/'
			option 'openvpn' '/etc/openvpn/'
			option 'passwd' '/etc/passwd'
			option 'opkg' '/etc/opkg.conf'
			option 'firewall' '/etc/firewall.user'
			option 'uploads' '/lib/uci/upload/'

	config 'internal' 'languages'
			option 'en' 'English'

	config 'internal' 'sauth'
			option 'sessionpath' '/tmp/luci-sessions'
			option 'sessiontime' '3600'

	config 'internal' 'ccache'
			option 'enable' '1'

	config 'internal' 'template'
			option 'compiler_mode' 'file'
			option 'compiledir' '/tmp/luci-templatecache'

	config 'internal' 'themes'
			option 'OpenWrt' '/luci-static/openwrt.org'

	==============luci_ethers==============

	==============luci_hosts==============

	==============network==============
	config interface loopback
	option ifname   lo
	option proto    static
	option ipaddr   127.0.0.1
	option netmask  255.0.0.0

	config interface lan
	option ifname   eth0
	option type     bridge
	option proto    static
	option ipaddr   192.168.1.1
	option netmask  255.255.255.0

	config interface wan
	option ifname   ath0
	option proto    dhcp
	==============system==============

	config 'system'
			option 'hostname' 'OpenWrt'
			option 'zonename' 'UTC'
			option 'timezone' 'GMT0'

	config 'button'
			option 'button' 'reset'
			option 'action' 'released'
			option 'handler' 'logger reboot'
			option 'min' '0'
			option 'max' '4'

	config 'button'
			option 'button' 'reset'
			option 'action' 'released'
			option 'handler' 'logger factory default'
			option 'min' '5'
			option 'max' '30'

	==============ucitrack==============
	config network
			option init network
			list affects dhcp

	config wireless
			list affects network

	config firewall
			option init firewall
			list affects luci-splash
			list affects qos

	config olsr
			option init olsrd

	config dhcp
			option init dnsmasq

	config dropbear
			option init dropbear

	config httpd
			option init httpd

	config fstab
			option init fstab

	config qos
			option init qos

	config system
			option init led

	config luci_hosts
			option init luci_hosts
			list affects dhcp

	config luci_ethers
			option init luci_ethers
			list affects dhcp

	config luci_splash
			option init luci_splash

	config upnpd
			option init miniupnpd

	config ntpclient
			option init ntpclient

	config samba
			option init samba

	config tinyproxy
			option init tinyproxy
	==============wireless==============
	config wifi-device  wifi0
	option type     atheros
	option disabled 0

	config wifi-iface
	option device   wifi0
	option mode     sta
	option ssid     OpenWrt
	option encryption none
