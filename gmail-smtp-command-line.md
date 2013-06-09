# Using Gmail SMTP from command line

### Install msmtp

	emerge mail-mta/msmtp

### Configure

Create file `/etc/msmtprc`

	account default
	host smtp.gmail.com
	tls on
	tls_certcheck off
	tls_starttls off
	port 465
	auth on
	user foo@gmail.com
	from foo@gmail.com
	password YOUR_GMAIL_PASSWORD
	logfile /var/log/msmtp.log

### Send

	(echo "Subject: SUBJECT"; echo; echo "MESSAGE") | msmtp destination_address@example.com
