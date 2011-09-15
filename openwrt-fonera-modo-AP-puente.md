# La Fonera en modo AP-puente con OpenWrt

Cómo configurar [La Fonera](http://wiki.fon.com/wiki/La_Fonera) como un AP (WPA-PSK) que haga de puente entre las dos interfaces, partiendo de la configuración que viene por defecto tras instalar  el firmware [OpenWrt](http://kamikaze.openwrt.org/) KAMIKAZE 7.09.

## Configurar el acceso a Internet a travós del puerto Ethernet

Modificar `/etc/config/network` para que quede de esta forma

	config interface loopback
		option ifname   lo
		option proto    static
		option ipaddr   127.0.0.1
		option netmask  255.0.0.0

	config interface lan
		option ifname   eth0
		option type     bridge
		option proto    static
		option ipaddr   192.168.0.6
		option netmask  255.255.255.0
		option gateway  192.168.0.1
		option dns      192.168.0.2

Reiniciar para que los cambios tengan efecto.

## Instalar los paquetes necesarios

Para poder crear el punto de acceso WPA necesitamos instalar el paquete hostapd (que a su vez instala las dependencias libopenssl y zlib)

	opkg update
	opkg install hostapd


## Configurar la red WiFi

Modificar `/etc/config/wireless` para que quede de esta forma

	config wifi-device  wifi0
		option type      atheros
		option channel   5
		option diversity 0
		option txantenna 1
		option rxantenna 1
		option disabled  0

	config wifi-iface
		option device   wifi0
		option network  lan
		option mode     ap
		option ssid     Fonera
		option hidden   0
		option encryption psk
		option key topsecret

Reiniciar para que los cambios tengan efecto
