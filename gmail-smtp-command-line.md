# Using Gmail SMTP from command line

### Install msmtp

	emerge mail-mta/msmtp

### Configure

Create file `/etc/msmtprc`

	# Set default values for all following accounts.
	defaults
	auth on
	tls on
	tls_certcheck off
	tls_starttls off
	logfile /var/log/mail.log

	# Gmail account
	account gmail
	host smtp.gmail.com
	port 465
	from someuser@gmail.com
	user someuser
	password mySecretPassword

	# Set a default account
	account default : gmail

Make it defaul (only required for Debian, Gentoo already does it)

	ln -s /usr/bin/msmtp /usr/bin/sendmail

### Test

One liner

	(echo "Subject: SUBJECT"; echo; echo "MESSAGE") | msmtp destination_address@example.com

With a non default account

	(echo "Subject: SUBJECT"; echo; echo "MESSAGE") | msmtp -a anotherAccount destination_address@example.com

Multiple lines (Press `Ctrl+D` to send)

	sendmail destination_address@example.com
	Subject: SUBJECT

	MESSAGE
