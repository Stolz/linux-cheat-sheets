Generate the privatekey ...

	cd /etc/ssl/apache2/
	openssl genrsa -out exampledomain.com.key 2048

... and change to appropriate rights

	chmod 600 exampledomain.com.key

Generate a request by giving the private key

	openssl req -new -key exampledomain.com.key -out exampledomain.com.csr

Enter you domain name (*exampledomain.com*) when you are asked for *"Common Name (e.g. server FQDN or YOUR name)"*. If you want a certificate for all of you domains then entrer  "*.exampledomain.com"

Show the contents of your public-key-certificate

	cat exampledomain.com.csr

Login at www.cacert.org and create the server certificate (Server certificates -> New) and paste in the contents of the the exampledomain.com.csr file

After the certificate is created paste it from the CAcert-page into a file named exampledomain.com.crt

Apache config

	SSLEngine on
	SSLCertificateFile /etc/ssl/apache2/exampledomain.com.crt
	SSLCertificateKeyFile /etc/ssl/apache2/exampledomain.com.key

Restart apache

	/etc/init.d/apache2 restart
