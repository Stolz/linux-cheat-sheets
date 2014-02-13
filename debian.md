# VPS Debian

Pasos para configurar LAMP rápidamente en un VPS con Debian.

## Actualización de versión de Debian

Para saber la versión actual

	lsb_release -a

Para actualizar a la última editar `/etc/apt/sources.list` con los [repos más nuevos](http://debgen.simplylinux.ch/) y ejecutar

	apt-get update
	apt-get upgrade
	apt-get dist-upgrade

Cuando acabe, si se ha actualizado el kernel ejecutar

	reboot

## Configuración inicial

Instalar programas típicos

	apt-get install joe screen pydf htop atool nano colordiff

Locales

	dpkg-reconfigure locales

Teclado

	dpkg-reconfigure --priority=low console-data

Motd

	echo "" > /etc/motd

Hostname

	echo "server" > /etc/hostname
	echo "127.0.0.1 localhost" > /etc/hosts
	echo "MY_PUBLIC_IP server.example.com server" >> /etc/hosts
	hostname -F /etc/hostname

Zona horaria UTC

	dpkg-reconfigure tzdata

Screen

	joe ~/.screenrc
	hardstatus alwayslastline "%{dw} .- %{dB} %-w%50>%{KY}[%t]%{dB}%+w %{dB}%<%>%=%C:%s %d/%m/%Y %{dw} -. "

Configurador de servicios ncurses

	apt-get install rcconf
	rcconf

Ver programas instalados

	dpkg --get-selections

Para ejecutar comandos al iniciar añadirlos a `/etc/rc.local`.

## ~/.bashrc

Ademas de los [alias](https://github.com/Stolz/linux-cheat-sheets/blob/master/alias.md) añadir

	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '


## iptables

	touch /root/firewall-on /root/firewall-off
	chmod 750 /root/firewall-on /root/firewall-off

Contenido de `/root/firewall-on`

	#!/bin/sh

	#=== Flush/Reset ===========================================

	iptables -F
	iptables -X
	iptables -F -t nat
	iptables -X -t nat

	#=== Defaults ==============================================

	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT ACCEPT

	#=== Table FILTER ==========================================

	# Allow already established or related traffic
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	# Allow traffic from loopback
	iptables -A INPUT -i lo -j ACCEPT

	# Allow ICMP ping
	iptables -A INPUT -p icmp --icmp-type echo-request -m state --state NEW -j ACCEPT

	# Allow connecting to servers in this computer
	iptables -A INPUT -p tcp -m state --state NEW -m multiport --dport http,ssh,mysql -j ACCEPT

	#==== Save and show rules ==================================

	iptables-save > /etc/iptables.up.rules

	echo === FILTER =========================================
	echo
	iptables -L -n -v
	echo
	echo ==== NAT ===========================================
	echo
	iptables -L -n -v -t nat

Contenido `/root/firewall-off`

	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT

	iptables -F
	iptables -X
	iptables -F -t nat
	iptables -X -t nat

	echo === FILTER =========================================
	echo
	iptables -L -n -v
	echo
	echo ==== NAT ===========================================
	echo
	iptables -L -n -v -t nat

Para que se ejecute al iniciar

	touch /etc/network/if-pre-up.d/iptables
	chmod +x /etc/network/if-pre-up.d/iptables
	joe /etc/network/if-pre-up.d/iptables
	#!/bin/bash
	/sbin/iptables-restore < /etc/iptables.up.rules

## MySQL

	apt-get install mysql-server mysql-client

## Apache

	apt-get install apache2-mpm-prefork

La configuración general del servidor está en `/etc/apache2/apache2.conf` y no deberiamos cambiarla.
En caso de querer cambiar la configuración global usar `/etc/apache2/conf.d/httpd.conf`.
Es interesante activar muchas de las restricciones de `/etc/apache2/conf.d/security`.

Para activar o desactivar módulos de Apache

	a2enmod module
	a2dismod module

(estos programas en realidad lo único que hacen es crear o eliminar enlaces entre `/etc/apache2/mods-enabled/` y `/etc/apache2/mods-available/`).

Para activar SSL

	a2enmod ssl
	a2ensite default-ssl

Para activar mod_rewrite

	a2enmod rewrite

Para ver todos los módulos activados

	apache2ctl -l

Para crear hosts virtuales añadirlos a `/etc/apache2/sites-enabled/`. Para activar o desactivar un host virtual usar

	a2ensite site
	a2dissite site

(estos programas en realidad lo único que hacen es crear o eliminar enlaces entre `/etc/apache2/sites-enabled/` y `/etc/apache2/sites-available/`).


[Más información](http://debian-handbook.info/browse/stable/sect.http-web-server.html)


## PHP

	apt-get install php5 php5-mysql php5-tidy libapache2-mod-php5

Configurar `/etc/php5/apache2/php.ini` y `/etc/php5/cli/php.ini`.

El PHP incluido en Debian 7 (wheezy) no incluye el parche Suhosin pero el php.ini trata de cargarlo y por tanto produce errores. Para solucionarlo editar `/etc/php5/conf.d/suhosin.ini` y comentar la línea *extension=suhosin.so*.

Para que los cambio tenga efecto

	/etc/init.d/apache2 restart

## PhpMyAdmin

	apt-get install phpmyadmin

Si el paquete ya estaba instalado para configurarlo

	dpkg-reconfigure phpmyadmin

En fichero `/etc/apache2/conf.d/phpmyadmin.conf` crean un alias para poder acceder añadiendo '/phpmyadmin' a la URL de cualquiera de nuestros vhosts.

Por motivos de seguridad se recomienda borrar `/usr/share/phpmyadmin/setup/`.

## Correo

Para instalar Postfix (SMTP), Courier (POP3 e IMAP) y Squirrelmail (webmail) con dominios/usuarios virtuales mediante MySQL usar [este manual](http://www.howtoforge.com/virtual-users-and-domains-with-postfix-courier-mysql-and-squirrelmail-debian-wheezy).

## PTY allocation request failed on channel 0

	echo "none /dev/pts devpts defaults 0 0" >> /etc/fstab
	rm -rf /dev/ptmx
	mknod /dev/ptmx c 5 2
	chmod 666 /dev/ptmx
	umount /dev/pts
	rm -rf /dev/pts
	mkdir /dev/pts
	mount /dev/pts
