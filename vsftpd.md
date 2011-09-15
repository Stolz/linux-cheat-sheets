# vsftpd

### Instalation

	emerge vsftpd

### Set vsftpd to start on every boot

	rc-update add vsftpd default

### Generate SSL certificate

For secured connections you need a certificate

	cd /etc/ssl/certs
	openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/certs/vsftpd.pem -out /etc/ssl/certs/vsftpd.pem


### Start the vsftpd server

It may be a better idea starting it after the configuration ;)

	/etc/init.d/vsftpd start

## Configuration

I suggest that you read the documentation (man vsftpd.conf), then use this sample code as a guideline. This will configure vsftpd to allow login only to local users listed in `/etc/vsftpd/users`

Edit `/etc/vsftpd/vsftpd.conf` using your favorite text editor and copy this into there

	# ---- SERVER -----------------------------------------------------------------
	#Run in standalone mode (not inetd,xinet,...)
	listen=YES

	#Listen port  for incoming FTP connections (Defauly 21)
	#listen_port=21

	#Make sure PORT transfer connections originate from port 20 (ftp-data), needed by some clients
	#connect_from_port_20=yes

	#Passive connection ports
	pasv_min_port=2690
	pasv_max_port=2694

	#Allow write commands (Needed even if you want local users to be able to upload files)
	write_enable=YES

	#Show text IDs instead of numeric IDs in the user and group fields of directory listings
	text_userdb_names=YES

	#Activate logging of transfers(uploads/downloads) to /var/log/vsftpd.log
	xferlog_enable=YES
	#also log the FTP protocol
	log_ftp_protocol=YES

	#Hide (but allow download) file patterns
	hide_file={.*}

	# Set some limits:
	max_clients=15
	max_per_ip=5
	#The maximum data transfer rate permitted, in bytes per second, for local authenticated users.
	#local_max_rate=...

	# ---- SSL --------------------------------------------------------------------
	#Support secure connections via SSL
	ssl_enable=YES

	#Do not force SSL on data transfers
	force_local_data_ssl=NO

	#Do not force all non-anonymous logins to secure the password with SSL
	force_local_logins_ssl=NO

	#Certificate
	rsa_cert_file=/etc/ssl/certs/vsftpd.pem
	rsa_private_key_file=/etc/ssl/certs/vsftpd.pem

	# ----- LOGIN -----------------------------------------------------------------
	#Do not allow anonymous login
	anonymous_enable=NO

	#Allow local users logins (AKA non-anonymous logins)...
	local_enable=YES
	#... and also allow login to users listed in /etc/vsftpd/users ...
	userlist_enable=YES
	userlist_file=/etc/vsftpd/users
	#... but if a real user is not listed in /etc/vsftpd/users deny login
	userlist_deny=NO

	#Once a real user (non-anonymous user) is successfully logged, map it to the guest_username user...
	guest_enable=YES
	guest_username=ftp
	#... and chroot them into their /home/ ...
	chroot_local_user=YES
	# ... or override ${HOME} and chroot all users into the next directory ...
	# local_root=/var/ftp
	#... with the privileges of a local user
	virtual_use_local_privs=YES

	#The permissions with which uploaded files are created.
	file_open_mode=0660
	#Mask that will be applied to file_open_mode (0007 = remove all permissions for others than owner and group)
	local_umask=0007
/Stolz/linux-cheat-sheets/blob/master/LICENCIA.md
[License](LICENSE.md)