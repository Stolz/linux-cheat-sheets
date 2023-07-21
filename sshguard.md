# SSHguard

[SSHguard](https://www.sshguard.net/) monitors log files of services running on your machine and when it detects that someone is doing something bad to a service it adds a firewall rule that blocks the IP address of who abused it. After some time, it releases the blocking.

Installation

	emerge app-admin/sshguard

Add these required iptables rules

	# Create a new chain in which sshguard will append blocking rules
	iptables -N sshguard

	# Block any traffic from abusers. This rule must be added before any other rules processing the ports that sshguard is protecting
	iptables -A INPUT -j sshguard

	/etc/init.d/iptables save

Sample `/etc/sshguard.conf` configuration file

	BACKEND="/usr/libexec/sshg-fw-iptables"
	FILES="/var/log/messages"
	THRESHOLD=10
	BLOCK_TIME=300
	DETECTION_TIME=3600
	IPV6_SUBNET=128
	IPV4_SUBNET=32

Sample `/etc/conf.d/sshguard` configuration file

	# Initial (empty) options.
	SSHGUARD_OPTS=""

	# Files to monitor
	#   -l <source>
	#SSHGUARD_OPTS="${SSHGUARD_OPTS} -l /var/log/auth.log"

	# White listing
	#   -w <addr/host/block/file>
	SSHGUARD_OPTS="${SSHGUARD_OPTS} -w 192.168.0.0/24"

	# Define how long in milliseconds start-stop-daemon waits to check that
	# sshguard is still running before calling success or failure.
	# Values lower than the default of 999 are probably not useful.
	SSHGUARD_WAIT="999"

Edit `/etc/syslog-ng/syslog-ng.conf` to instruct syslog-ng to pass service logs to sshguard

	# For sshguard
	filter f_authpriv { facility(auth, authpriv); };
	log { source(src);  filter(f_authpriv);  destination(messages); };

Restart syslog-ng

	/etc/init.d/syslog-ng restart

Add to the rc levels to ensure it starts at every boot

	rc-update add sshguard default

Start the service

	/etc/init.d/sshguard start
