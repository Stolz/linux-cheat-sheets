# NTP

Network Time Protocol (NTP) es un protocolo de Internet para sincronizar los relojes de los sistemas informáticos a través de la red. Está diseñado para resistir los efectos de la latencia variable.

### Instalación

	emerge net-misc/ntp

## Servidor

### Configuracion del servidor

	$EDITOR /etc/ntp.conf

Descomentar la última y modificarla para permitir que los ordenadores de la LAN usen el servicio


	restrict 192.168.1.0 mask 255.255.255.0 nomodify nopeer notrap

### Firewall

	iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -t filter -A INPUT -p udp -m udp --sport 123 --dport 123 -j ACCEPT


### Iniciar el servicio y añadirlo al arranque

	/etc/init.d/ntpd start
	rc-update add ntpd default

### Hacer que la hora de la BIOS se sincronice con la del sistema al apagar

## Cliente

Indicar en `/etc/conf.d/ntp-client` los servidores a usar

### Iniciar el servicio y añadirlo al arranque

	/etc/init.d/ntp-client start
	rc-update add ntp-client default

### Hacer que se siconronice cada día

	echo "#! /bin/sh
	/etc/init.d/ntp-client restart" > /etc/cron.daily/ntp-client
	chmod 755 /etc/cron.daily/ntp-client