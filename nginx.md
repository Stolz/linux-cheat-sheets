# Servidor WEB nginx

Antes de instalar configurar las USE añadiendo a `/etc/portage/package.use` esto:

	www-servers/nginx -* http pcre ssl -syslog nginx_modules_http_access nginx_modules_http_auth_basic nginx_modules_http_autoindex nginx_modules_http_fastcgi -map -nginx_modules_http_referer nginx_modules_http_rewrite

La explicación de las USE escogidas:

- **http** Lo minimo para poder servir webs por HTTP (ports, locations, error pages, aliases, ...).
- **pcre** Para poder usar expresiones regulares en la directiva "location" y en el modulo "rewrite".
- **sss** Para poder servir HTTPS.
- **syslog** Para poder enviar los logs a syslog. De momento no lo voy a activar porque pienso hacer log en archivos .log ordinarios.
- **access** Para poder permitir/denegar el acceso por IP con las directivas "allow" y "deny".
- **auth_basic** Para poder usar HTTP Basic Authentication (que el navegador te pida usuario y contraseña).
- **autoindex** Para poder generar páginas con el índide del contenudo de un directorio cuando no se encuentra archivo index.
- **fastcgi**  la usamos para servir PHP.
- **map** Para crear grupos de variables que se pueden reutilizar luego en plantillas de archivos de configuración. De momento no la activo pero puede ser util par aconfigurar VHOSTs sin tener que rescribir configs repetidas.
- **referer**  Sirve para poder limitar por Referer. De momento no lo activo pero puede ser util en el futuro
- **rewrite**  Similar a mod_rewrite de Apache (para cabiar la URL usando expresiones regulares).

Más detalles sobre las USE en http://wiki.nginx.org/Modules y http://wiki.nginx.org/InstallOptions

Para instalar el servidor nginx

	emerge www-servers/nginx -av

Configurarlo editando `/etc/nginx/nginx.conf`

Iniciar el sevidor

	/etc/init.d/nginx start

Cada vez que cambiemos alguna config

	/etc/init.d/nginx reload

Para que se ejecute al iniciar

	rc-update add nginx default

## PHP


nginx no soporta PHP como módulo del servidor por lo que tenemos que ejecutarlo como CGI. PHP incluye una implementación nativa de FastCGI llamamda PHP-FPM.

Para instalar PHP-FPM

	USE="fpm" emerge dev-lang/php -av

Cambiar la configuración global de PHP editar `/etc/php/fpm-phpVERSION/php.ini`.

Para usar PHP-FPM con unix sockets en vez de TCP editar `/etc/php/fpm-phpVERSION/php-fpm.conf` y cambiar

	listen = 127.0.0.1:9000

por

	listen = /run/php5-fpm.socket

Para iniciar el sevidor PHP-FPM (Si todo ha ido bien se debe de haber creado el socket en /run/php5-fpm.socket)

	/etc/init.d/php-fpm start

Para que se ejeucte al iniciar

	rc-update add php-fpm default


Para que nginx use PHP-FPM para interpretar los archivos .php añadir a `/etc/nginx/fastcgi.conf`

	location ~ .php$ {
		fastcgi_pass unix:/run/php5-fpm.socket;
	}

Y luego en todas nuestras directivas `server` que vayan a servir PHP añadir una directiva

	include /etc/nginx/fastcgi.conf

Para que los cambios tengan efectos

	/etc/init.d/nginx reload

## Sample config file

	####################
	### MAIN CONTEXT ###
	####################

	#Number of worker processes. Set it to the number of available CPU cores as a good start value or use 'auto' to autodetect it
	worker_processes 4;

	#User and group used by worker processes
	user nginx nginx;

	#Skip superfluous info in the main error log file
	error_log /var/log/nginx/error_log error;

	#Limit number of files a worker process can open
	worker_rlimit_nofile 1024;

	######################
	### EVENTS CONTEXT ### Controls how Nginx processes connections
	######################
	events {
			#We are in Linux so lets use the most eficient method available for it
			use epoll;

			#Limit number of simultaneous connections that can be opened by a worker process (It may no exceed worker_rlimit_nofile)
			worker_connections 1024;

			#NOTE: total amount of users you can serve in 1 second = worker_processes*worker_connections/keepalive_timeout

			#If you have a very busy server uncomment the next directive to accept new connections all at a time instead of only one at a time but be aware it could fllod your server in a way that new connection will make the server not able to precess existing connections
			#multi_accept on;
	}

	####################
	### HTTP CONTEXT ###
	####################
	http{

			#List of all mime types files that will be handled
			include /etc/nginx/mime.types;

			#If the requestes file doesn't match any of the mime types lets set a default one
			default_type application/octet-stream;

			#Optimize data transfers
			sendfile on;
			tcp_nopush on;
			tcp_nodelay on;

			#Close connections earlier possible and Ask browsers to close connection, so that the server does not have to
			keepalive_timeout 35 20;

			# allow the server to close the connection after a client stops responding. Frees up socket-associated memory.
			reset_timedout_connection on;

			#By default disable symlinks for security reasons
			disable_symlinks on;

			#Define index file
			index index.php index.html index.htm;

			#Define custom log format
			log_format main
			'$remote_addr - $remote_user [$time_local] '
			'"$request" $status $bytes_sent '
			'"$http_referer" "$http_user_agent" ';

			#Gentoo defaults
			ignore_invalid_headers on;
			connection_pool_size 256;
			client_header_buffer_size 1k;
			large_client_header_buffers 4 2k;
			request_pool_size 4k;
			output_buffers 1 32k;
			postpone_output 1460;

			###############################
			### VIRTUAL SERVERS CONTEXT ###
			###############################
			server {
				listen *:80 default_server;
				server_name example.com www.example.com;
				root /var/www/example.com/htdocs;
				access_log /var/log/nginx/example.com/access_log main;
				error_log /var/log/nginx/example.com/error_log info;
			}
	}

## webapp-config

Editar /etc/vhosts/webapp-config y establecer

	vhost_server="nginx"
