# Notas sobre [OpenWrt](http://kamikaze.openwrt.org/)

Quitar los programas PPP que no voy a usar para ganar espacio en la Fonera

	ipkg remove *ppp*


Si queremos cambiar el nombre del host, configurar `/etc/config/system`

	config system
		option hostname Fonera

Si queremos desactivar el servidor DHCP

	/etc/init.d/dnsmasq stop
	/etc/init.d/dnsmasq disable

Para ver la salida del log

	logread

La fecha se pierde en cuanto reiniciamos por eso conviene poner en hora la Fonera nada mas arrancar para evr la hora correcta en los logs. Por ejemplo, para ponerel dia 27 de Diciembre de 2007 a las 4:55

	date 122704552007

Para ejecutar comandos al iniciar sesion o establecer alias y cosas similares ponerlos en `/etc/profile`

Para que el servidor DHCP siempre asigne la misma IP a la misma MAC editar el fichero `/etc/ethers` de la siguiente forma

	DIRECCION_MAC DIRECCION_IP
