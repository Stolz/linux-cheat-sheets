# Comandos para interfaces de red

## Aplicable a tarjetas cableadas e inalámbricas


### Ver todas las interfaces (tarjetas) de red instaladas en el ordenador

	ifconfig -a

### Ver solo las activas

	ifconfig

### Activar una interfaz

	ifconfig eth0 up

### Desactivar una interfaz

	ifconfig eth0 down

### Asignar los parámetros de red de forma manual

	ifconfig eth0 MI_DIRECCION_IP netmask MI_MASCARA broadcast MI_DIRECCION_BROADCAST
	route add -net default gw MI_PUERTA_DE_ENLACE
	echo "nameserver MI_DNS" >>/etc/resolv.conf

### Asignar los parámetros de red de forma dinámica

	dhcpcd eth0

Para más verborrea añadir el parámetro -d


### Borrar una ruta

	route del default
o

	route del -v -net 192.168.0.0/24

### Añadir una ruta estatica

	route add -net 10.0.0.0 netmask 255.255.255.0 gw 192.168.1.50

## Aplicable sólo a tarjetas inalámbricas

### Mostrar todas las redes inalámbricas al alcance:

	iwlist wlan0 scan

### Conectarse a una red WEP

	ifconfig wlan0 up
	iwconfig wlan0 essid MI_ESID mode managed channel auto rate auto key 1234567890

Los valores anteriores permanecen activos entre las posteriores llamadas a iwconfig. Para reestablecerlos

	iwconfig wlan0 channel 0 essid any ap any

Una vez establecidos los valores de iwconfig, podemos asignar los valores de red (IP,puerta de enlace y servidor DNS) como se indica en el apartado común a redes cableadas y wifi.

### Mostrar los comandos privadós específicos del driver de nuestra tarjeta inalámbrica

	iwpriv wlan0

### Cambiar el valor de los comandos privados

	iwpriv wlan0 COMANDO_PRIVADO VALOR_DEL_COMANDO

### Para conectarse a una red WPA

	wpa_supplicant -D wext -c /etc/wpa_supplicant/wpa_supplicant.conf -W -i wlan0 -d