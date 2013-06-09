# La Fonera en modo cliente con OpenWrt

Cómo configurar [La Fonera](http://wiki.fon.com/wiki/La_Fonera) con el firmware [OpenWrt](http://kamikaze.openwrt.org/) KAMIKAZE en modo cliente. **NOTA:** De momento (kamikaze 7.09) el modo bridge no funciona en modo cliente.

Esta configuración es para conectar a mi AP con ESSID `MI_RED_WIFI` que usa WPA2. Para otras configuraciones consultar <http://wiki.openwrt.org/OpenWrtDocs/Kamikaze/ClientMode>

### /etc/config/network
	config interface loopback
		option ifname   lo
		option proto    static
		option ipaddr   127.0.0.1
		option netmask  255.0.0.0

	config interface lan
		option ifname   eth0
		option proto    static
		option ipaddr   192.168.0.1
		option netmask  255.255.255.0

	config interface wan
		option ifname   ath0
		option proto    dhcp


### /etc/config/wireless

	config wifi-device  wifi0
		option type      atheros
		option channel   5
		option diversity 0
		option txantenna 1
		option rxantenna 1

	config wifi-iface
		option device   wifi0
		option network  wan
		option mode     sta
		option ssid     MI_RED_WIFI
		option encryption psk2
		option key topsecret

Como nuestar red usa WPA antes tendremos que instalar el paquete wpa-supplicant

	ipkg install wpa-supplicant
