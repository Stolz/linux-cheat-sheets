# VPS Debian

Pasos para configurar LAMP rápidamente en un VPS con Debian.

## Actualización de versión de Debian

Para saber la versión actual

	lsb_release -a

Para actualizar a la última editar `/etc/apt/sources.list` con los repos más nuevos (sacarlos de Internet) y ejecutar

	apt-get update
	apt-get upgrade
	apt-get dist-upgrade

Cuando acabe

	reboot

## Configuración inicial

Instalar programas típicos

	apt-get install joe screen pydf htop atool nano colordiff

Locales

	dpkg-reconfigure locales

Teclado

	dpkg-reconfigure --priority=low console-data

Hostname

	echo "hostname" > /etc/hostname
	hostname -F /etc/hostname
	#Añadir el hostname en /etc/hosts

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

## ~/.bashrc

	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	alias ls='ls -lh --color'
	alias la='ls -a'
	alias joe='joe --wordwrap'
	alias rm='rm -i'
	alias modprobe='modprobe -v'
	alias rmmod='rmmod -v'
	alias df='pydf'
	alias l='locate -i'
	alias netstat='netstat -plutanW'
	alias s='ssh'
	alias top='htop'
	alias grep='grep --colour=auto --exclude-dir=.svn --exclude=*.svn-base --exclude-dir=.git'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
	alias descomprimir='aunpack'
	alias comprimir='apack'

	PROMPT_COMMAND='if [[ $? -ne 0 ]]; then echo  -ne "\033[1;31m:(\033[0m\n";fi'

	#Colored man pages
	man() {
		# begin blinking
		# begin bold
		# end mode
		# end standout-mode
		# begin standout-mode - info box
		# end underline
		# begin underline

		env LESS_TERMCAP_mb=$(printf "\e[1m") \
		LESS_TERMCAP_md=$(printf "\e[1;32m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;37m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;33m") \
		man "$@"
	}



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

Para crear hosts virtuales añadirlos a `/etc/apache2/sites-enabled/`. Para activar o desactivar un host virtual usar

	a2ensite site
	a2dissite site

(estos programas en realidad lo único que hacen es crear o eliminar enlaces entre `/etc/apache2/sites-enabled/` y `/etc/apache2/sites-available/`).

Para activar SSL

	a2enmod ssl
	a2ensite default-ssl

[Más información](http://debian-handbook.info/browse/stable/sect.http-web-server.html)


## PHP

	apt-get install php5 php5-mysql php5-tidy libapache2-mod-php5

Configurar `/etc/php5/apache2/php.ini` y `/etc/php5/cli/php.ini`

## Correo

Para instalar Postfix (SMTP), Courier (POP3 e IMAP) y Squirrelmail (webmail) con dominios/usuarios virtuales mediante MySQL usar [este manual](http://www.howtoforge.com/virtual-users-and-domains-with-postfix-courier-mysql-and-squirrelmail-debian-wheezy).
