# Servidor WEB Nginx

Antes de instalar configurar las USE añadiendo a `/etc/portage/package.use` esto:

	www-servers/nginx -* http pcre ssl -syslog nginx_modules_http_access nginx_modules_http_auth_basic nginx_modules_http_autoindex nginx_modules_http_fastcgi -map -nginx_modules_http_referer nginx_modules_http_rewrite nginx_modules_http_gzip

La explicación de las USE escogidas:

- **http** Lo minimo para poder servir webs por HTTP (ports, locations, error pages, aliases, ...).
- **pcre** Para poder usar expresiones regulares en la directiva "location" y en el modulo "rewrite".
- **ssl** Para poder servir HTTPS.
- **syslog** Para poder enviar los logs a syslog. De momento no lo voy a activar porque pienso hacer log en archivos .log ordinarios.
- **access** Para poder permitir/denegar el acceso por IP con las directivas "allow" y "deny".
- **auth_basic** Para poder usar HTTP Basic Authentication (que el navegador te pida usuario y contraseña).
- **autoindex** Para poder generar páginas con el índice del contenido de un directorio cuando no se encuentra archivo index.
- **gzip** Para poder comprimir páginas al vuelo con Gzip.
- **fastcgi**  la usamos para servir PHP.
- **map** Para crear grupos de variables que se pueden reutilizar luego en plantillas de archivos de configuración. De momento no la activo pero puede ser util par aconfigurar VHOSTs sin tener que rescribir configs repetidas.
- **referer**  Sirve para poder limitar por Referer. De momento no lo activo pero puede ser util en el futuro
- **rewrite**  Similar a mod_rewrite de Apache (para cabiar la URL usando expresiones regulares).

Más detalles sobre las USE en <http://wiki.nginx.org/Modules> y <http://wiki.nginx.org/InstallOptions>

Para instalar el servidor Nginx

	emerge www-servers/nginx -av

Configurarlo editando `/etc/nginx/nginx.conf`. Un posible ejemplo de configuración:

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

			# Enable Gzip compression
			gzip on;
			gzip_min_length 1100;
			gzip_buffers 16 8k;
			gzip_types text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript application/json;
			gzip_comp_level 2; # 1 is the least compression (fastest) and 9 is the most (slowest) compression
			gzip_proxied any;
			gzip_disable "MSIE [1-6]\.(?!.*SV1)";

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

Iniciar el sevidor

	/etc/init.d/nginx start

Cada vez que cambiemos alguna config

	/etc/init.d/nginx reload

Para que se ejecute al iniciar

	rc-update add nginx default

## PHP

Nginx no soporta PHP como módulo del servidor por lo que tenemos que ejecutarlo como CGI. Para ello podemos usar:

- PHP-FPM: Implementación FastCGI oficial de PHP.
- HHVM: Implementación FastCGI desarrollada por Facebook, más rápida pero todavía no soporta todas las extensiones de PHP.

Por motivos de rendimiento y puesto que no es habitual interpretar PHP en una máquina distinta de la que se encuenta el código, conviene configurar los intérpretes FastCGI para que usen sockets Unix en vez de TCP para las comunicarse con Nginx.

### PHP-FPM

Para instalar PHP-FPM

	USE="fpm" emerge dev-lang/php -av

Para usar Unix sockets en vez de TCP editar `/etc/php/fpm-phpVERSION/php-fpm.conf` y establecer

	[global]
	error_log = /var/log/php-fpm.log

	[www]
	listen = /var/run/php-fpm.socket
	listen.owner = nginx
	listen.group = nginx
	listen.mode = 0660
	listen.allowed_clients = 127.0.0.1

	user = nginx
	group = nginx

	pm = ondemand
	pm.max_children = 50

En caso de querer cambiar la configuración global de PHP cuando es interpretado mediante PHP-FPM editar `/etc/php/fpm-phpVERSION/php.ini`.

Para iniciar el sevidor PHP-FPM (Si todo ha ido bien se debe de haber creado el socket en /var/run/php-fpm.socket)

	/etc/init.d/php-fpm start

Para que se ejecute al iniciar

	rc-update add php-fpm default

Para que Nginx use PHP-FPM para interpretar los archivos .php añadir a `/etc/nginx/fastcgi.conf`

	location ~ .php$ {
		fastcgi_pass unix:/var/run/php-fpm.socket;
	}

Y luego en todas nuestras directivas `server` que vayan a servir PHP añadir una directiva

	include /etc/nginx/fastcgi.conf;

Para que los cambios tengan efectos

	/etc/init.d/nginx reload

### HHVM

Para instalar HHVM [seguir las instrucciones oficiales](https://github.com/facebook/hhvm/wiki/Building-and-installing-HHVM-on-Gentoo).

Para usar Unix sockets en vez de TCP crear el fichero `/etc/hhvm/server.ini` y con el siguiente contenido

	hhvm.server.type = fastcgi
	hhvm.server.file_socket=/var/run/hhvm/hhvm.sock


En caso de querer cambiar la configuración global de PHP cuando es interpretado mediante HHVM editar `/etc/hhvm/php.ini`.

Para iniciar el sevidor HHVM (Si todo ha ido bien se debe de haber creado el socket en /var/run/hhvm/hhvm.sock)

	/etc/init.d/hhvm start

Para que se ejecute al iniciar

	rc-update add hhvm default

Para que Nginx use HHVM para interpretar los archivos .php añadir a `/etc/nginx/fastcgi.conf`

	location ~ .php$ {
		fastcgi_pass unix:/var/run/hhvm/hhvm.sock;
	}

Y luego en todas nuestras directivas `server` que vayan a servir PHP añadir una directiva

	include /etc/nginx/fastcgi.conf;

Para que los cambios tengan efectos

	/etc/init.d/nginx reload

## webapp-config

Editar /etc/vhosts/webapp-config y establecer

	vhost_server="nginx"


## Directiva location

Explicación de cómo Nginx decide qué directiva location aplicar:

La directiva location puede ser de cuatro tipos:

[1] Coincidencia literal completa: Coincidencia exacta de todo
location = /foo/bar {...} #Coincide solo con "/foo/bar"

[2] Coincidencia literal inicial prioritaria: Coincide el comienzo
location ^~ /foo {...} #Coincide con todo lo que comience con "/foo"

[3] Coincidencia regex: Coincide con la expresión segular
location ~  \.html$ {...} #Coincide con todo lo que acabe en ".html"
location ~* \.html$ {...} #Insensible a mayúsculas. Coincide con todo lo que acabe en ".html" o ".HTML"

[4] Coincidencia literal inicial: Coincide el comienzo
location /foo {...} #Coincide con todo lo que comience con "/foo"

En caso de existir más de una directiva location en un server se escoge y usa SOLO UNA.

La forma en la Nginx escoge qué directiva location aplicar es la siguiente:

1º Se buscan una tipo [1] que coincida. Si se encuentra se usa y se para el proceso.
2º Se buscan la tipo [2] más larga. Si se encuentra se usa y se para el proceso.
3º Se buscan las tipo [3] en el orden en el que aparecen. La primera que coincide se usa y se para el proceso.
4º Se buscan la tipo [4] más larga. Si se encuentra se usa y se para el proceso.
