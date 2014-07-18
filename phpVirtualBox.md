# phpVirtualBox en Gentoo

# PHP

Instalar PHP

	USE="gd session simplexml soap unicode" emerge -av dev-lang/php

## VirtualBox

Instalar VirtualBox

	USE="headless java vboxwebsrv" emerge -av app-emulation/virtualbox

Si además se necesita soporte para emulación USB 2.0 o para VRDP (Consola remota) añadir USE="extensions".

Crear usuario para ejecutar las maquinas virtuales

	superadduser virtualbox
	Initial group: vboxusers
	Shell: /sbin/nologin

Configurar el servicio que lanza el WebService para que se ejecute con el usuario que acabamos de crear poniendo en `/etc/conf.d/vboxwebsrv`

	VBOXWEBSRV_USER="virtualbox"

Iniciar el servicio que creará el WebService SOAP

	rc-update add vboxwebsrv default
	/etc/init.d/vboxwebsrv start

## phpVirtualBox

Instalar phpVirtualBox

	emerge -av app-emulation/phpvirtualbox

Copiar a un vhost

	webapp-config -I -h <host> -d <directory> phpvirtualbox 4.3.0

Configurar

	cd /var/www/<host>/htdocs/<directory>
	cp -a config.php-example config.php

Establecer en `config.php`

	$username = 'virtualbox'; // El nombre de usuario que hemos creado antes
	$password = 'foobar';     // La contraseña del usuario que hemos creado antes
	$location = 'http://127.0.0.1:18083/';
	$language = 'es';
	$enableAdvancedConfig = true;


Visitar http://<host>/<directory>/ y usar como usuario/contraseña "admin/admin".
Una vez autenticado cambiar la contraseña en el menú "Archivo -> Cambiar contraseña".
Se puede cambiar la ruta en la que se guardan las máquinas virtuales en el menú "Archivo -> Preferencias -> General -> Carpeta predeterminada de máquinas".


