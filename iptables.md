# netfilter/iptables por la via rápida

### Instalación en Gentoo

	emerge iptables

Editar `/etc/conf.d/iptables` y establecer

	SAVE_ON_STOP="no"


Cargar los módulos

	modprobe -v iptable_filter

Si queremos guardar nuestra configuración actual

	/etc/init.d/iptables save

y para restaurarla

	/etc/init.d/iptables restore

Para iniciar el servicio

	/etc/init.d/iptables start

Para añadirlo al inicio de sistema

	rc-update add iptables default

## Sintaxis de una regla

Una regla de IPTABLES tiene la siguiente forma:

	iptables [-t <tabla>] <comando> <cadena> <parámetro 1><opción 1>...<parámetro N> <opción N> <acción>

Donde:

### &lt;tabla&gt;

- __filter:__ Es la tabla por defecto y la que se encarga de filtrar los paquetes de red.
- __nat:__ Es la tabla usada para alterar las direcciones origen y/o destino en los paquetes de entrada ó salida que establecen conexiones.
- __mangle:__ Permite realizar alteraciones locales del origen o destino de los paquetes, lo que permite por ejemplo, balancear el tráfico que accede a un servicio a un conjunto de ordenadores.
- __raw:__ Permite configurar excepciones en el seguimiento de los paquetes de las conexiones.

### &lt;comando&gt;

- __-A__ Añade la regla especificada al final de la cadena especificada.
- __-C__ Chequea una regla antes de que sea añadida por el usuario a la cadena especificada.
- __-D__ Borra una regla de la cadena especificada. Puede especificarse por un número que indique su posición, comenzando a contar siempre en 1, o bien escribir la regla completa a borrar.
- __-E__ Renombra una cadena definida por el usuario. Esta acción no afecta a la estructura de la tabla donde se encuentra la cadena.
- __-F__ Borra todas la reglas de la cadena especificada. Si no se especifica la cadena, todas las reglas de todas las cadenas son borradas.
- __-h__ Proporciona información de ayuda.
- __-I__ Inserta una regla en la cadena en la posición indicada. Si no se indica ninguna posición la regla es insertada al principio de la cadena.
- __-L__ Lista todas las reglas. Los valores -v, -x y -n, permiten especificar que la salida sea más extensa, que se de en valores exactos y no abreviados con K (miles), M (millones), etc., y que se de en valor numérico de direcciones IP y puertos, respectivamente.
- __-N__ Crea una nueva cadena con el nombre especificado por el usuario.
- __-P__ Asigna la política por defecto a una cadena, de forma que si un paquete no corresponde a ninguna regla, esta será la acción por defecto a aplicar.
- __-R__ Reemplaza la regla situada en la posición indicada de la cadena por la regla especificada. Como en la opción –D empieza a contar en 1.
- __-X__ Borra una cadena especificada por el usuario. Borrar una cadena predefinida de una tabla no esta permitido.
- __-Z__ Inicializa a cero el contador de bytes y paquetes en todas las cadenas de una tabla.

### &lt;cadena&gt;

- tabla filter:

 - __INPUT:__ Se aplica a los paquetes destinados a un proceso local.
 - __OUTPUT:__ Se aplica a los paquetes generados de forma local por un proceso y que van a ser enviados por la red.
 - __FORWARD:__ Se aplica a los paquetes recibidos por un dispositivo de red y que van a ser reenviados por otro dispositivo de red del ordenador sin ser procesados por algún proceso local.

- tabla nat:

 - __PREROUTING:__ Se aplica a los paquetes recibidos por un dispositivo de red antes de ser procesados.
 - __OUTPUT:__ Se aplica a los paquetes generados por un proceso local antes de ser enviados.
 - __POSTROUTING:__ Se aplica a los paquetes antes de que salgan a la red.

- tabla mangle:

 - __PREROUTING:__ Se aplica a los paquetes recibidos por un dispositivo de red antes de ser enrutados.
 - __INPUT:__ Se aplica a los paquetes destinados a un proceso local.
 - __OUTPUT:__ Se aplica a los paquetes generados de forma local por un proceso antes de ser enrutados.
 - __FORWARD:__ Se aplica a los paquetes que son reenviados a través de dos dispositivos de red del ordenador sin la intervención de ningún proceso local.
 - __POSTROUTING:__ Se aplica a los paquetes antes de salir a la red.

- tabla raw:

 - __PREROUTING:__ Se aplica a los paquetes recibidos por cualquier dispositivo de red.
 - __OUTPUT:__ Se aplica a los paquetes generados localmente por un proceso local.

### &lt;parámetro&gt;

Solo los típicos, consula la documentación para ver todos

- __-d:__ dirección IP y/o red que es el destino del paquete.
- __-i:__ Identifica el dispositivo de red de entrada, como ppp0 ó eth0, al que se debe aplicar la regla. Si ningún dispositivo de red es especificado se toma que todos los dispositivos de red existentes.
- __-j:__ Especifica una acción concreta cuando el paquete coincide con la regla.
- __-o:__ Similar a -i pero para interfaces de salida
- __-p:__ Selecciona el protocolo IP al que se aplicará la regla, por ejemplo tcp, udp, icmp, etc., o all para todos los protocolos soportados.
- __-s:__ Selecciona el nombre del ordenador, dirección IP o red, que es el origen del paquete.
- __-m:__ Activa el módulo indicado. Iptables soporta módulos para buscar distintos tipos de coincidencias en los paquetes. Esta opcion activa el módulo indicado.

### &lt;acción&gt;

- __ACCEPT:__ Que indica que el paquete no debe ser analizado por el resto de reglas y tablas y debe permitirse su continuación hasta el destino.
- __DROP:__ Que especifica que el paquete debe ser rechazado sin enviar ningún tipo de mensaje a la dirección de origen del paquete.
- __QUEUE:__ Indica que el paquete debe ser enviado para su análisis a un módulo en el espacio del usuario.
- __RETURN:__ Devuelve el paquete a la regla siguiente a la que ocasiono la llamada a la regla que contiene esta acción. Suele ser utilizada en las reglas que se encuentran en las cadenas definidas por los usuarios.


## Configurar el kernel

### Configuración básica

Estas son las opciones mínimas para usar IPTABLES como firewall (es decir, dar soporte a la tabla filter):


	[*] Networking support --->
		Networking options --->
			[*] Network packet filtering framework (Netfilter) --->
				Core Netfilter Configuration --->
					<M> Netfilter Xtables support (required for ip_tables)
				IP: Netfilter Configuration --->
					<M> IP tables support (required for filtering/masq/NAT)
					<M> Packet filtering

Con esta configuración mínima podremos hacer reglas básicas con un aspecto similar a este:

	iptables -A INPUT -p tcp --sport http -j ACCEPT

### Relacionar paquetes con conexiones

Si además queremos poder hacer un seguimiento de los paquetes que han pasado por el ordenador para saber cuales son consecuencia de las conexiones que hemos realizado o si queremos utilizar el estado de una conexión (INVALID, ESTABLISHED, NEW, RELATED) como condición en una regla, entonces debemos de añadir la siguiente opción:

	[*] Networking support --->
		Networking options --->
			[*] Network packet filtering framework (Netfilter) --->
				Core Netfilter Configuration --->
					<M> Netfilter connection tracking support
					<M> "state" match support
				IP: Netfilter Configuration --->
					<M> IPv4 connection tracking support (required for NAT)

Con esta configuración podremos hacer reglas con un aspecto similar a este:

	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

### Rangos de puertos

Para poder indicar rangos de puertos en una regla no es necesario activar nada, con separarlos por `:` es suficiente. Por ejemplo:

	iptables -A INPUT -p tcp --sport 500:550 -j ACCEPT

En cambio, para poder indicar una lista de puertos no correlativos tenemos que añadir una nueva opción:

	[*] Networking support --->
		Networking options --->
			[*] Network packet filtering framework (Netfilter) --->
				[*] Advanced netfilter configuration
				Core Netfilter Configuration --->
					<M> "multiport" Multiple port match support

Con esta configuración podremos hacer reglas con un aspecto similar a este:

	iptables -A INPUT -p tcp -m multiport --sport http,https -j ACCEPT

__NOTA:__ Con esta sintaxis es en algunos servidores algunos puertos aletorios a veces no se abren (comprobado con nmap), pero en cambio con esta otra sintaxis sí van:

	iptables -A INPUT -p tcp --match multiport --dports http,https -m state --state NEW -j ACCEPT


### Dejar constancia de los paquetes en el syslog

Podemos usar la función LOG de iptables para saber qué paquetes se están filtrando. Esta función es útil por ejemplo para saber qué intentos de ataque ha sufrido nuestra máquina o qué uso se intenta hacer de la red. Tambiés es útil para conocer los puertos que usa algún programa poco común el cual hemos observado que deja de funcionar con el firewall activado. Para disponer de esta función de iptables tenemos que añadir una nueva opción:

	[*] Networking support --->
		Networking options --->
			[*] Network packet filtering framework (Netfilter) --->
				IP: Netfilter Configuration --->
					<M> LOG target support

Con esta configuración podremos hacer reglas con un aspecto similar a este:

	iptables -A INPUT -j LOG --log-level 2 --log-prefix "Firewall: "

Si además quieres que no se llene el log puedes usar el modulo limit para limitar cuanta informacion se guarda. Para activarlo hacer lo mismo que en c) pero en el ultimo paso marcar

			<M> "limit" match support

Con lo que la regla con el límite aplicado quedaría:

	iptables -A INPUT -m limit --limit 3/minute --limit-burst 3 -j LOG --log-level 2 --log-prefix "Firewall: "

### Compartir Internet:

Añadir al kernel soporte para NAT y MASQUERADE

	[*] Networking support --->
		Networking options --->
			[*] Network packet filtering framework (Netfilter) --->
				IP: Netfilter Configuration --->
					<M> IPv4 NAT
					<M>   MASQUERADE target support

Añadir a las reglas de limpiado la tabla NAT

	iptables -F -t nat
	iptables -X -t nat

Cambiar la politica por defecto de FORWARD para que sea aceptado tráfico dirigido a otros

	iptables -P FORWARD ACCEPT

Activar el acceso compartido a Internet (Se entiende que eth1 es tu tarjeta con acceso a Internet)

	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

Para activar el reenvio IP de forma permanente añade a `/etc/sysctl.conf` la siguiente línea

	net.ipv4.ip_forward = 1

## Ejemplo de configuración

El siguiente ejemplo asume que se ha instalado iptables en un ordenador (router) que va a proporcionar acceso a Internet a otros ordenadores de su misma red local y además va a protegerlos a modo de firewall. Dicho ordenador tiene dos tarjetas de red conectadas: `eth0` que sirve para conectar a Internet (WAN) y `eth1` que sirve para conectar a la red local (LAN).

Desde Internet se puede acceder al servidor web (puerto 80) y al servidor SSH (puerto 22) que se encuentran en el ordenador router. Además, se puede acceder desde Internet al servidor SSH de uno de los ordenadores de la LAN (192.168.1.2) a través del puerto 2222 (que es redirigido al puerto 22 de 192.168.1.2)

---

	#=== Flush/Reset ===========================================

	iptables -F
	iptables -X
	iptables -F -t nat
	iptables -X -t nat

	#=== Defaults ==============================================

	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT ACCEPT

	#=== FILTER Table ==========================================

	# Allow already established or related traffic
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	# Allow traffic from loopback
	iptables -A INPUT -i lo -j ACCEPT

	# Allow ICMP ping
	iptables -A INPUT -p icmp --icmp-type echo-request -m state --state NEW -j ACCEPT

	# Allow connecting to servers in this computer
	iptables -A INPUT -p tcp -m state --state NEW -m multiport --dport http,ssh -j ACCEPT

	#==== NAT Table ============================================

	# Define interfaces:
	# - WAN is the public/external network
	# - LAN is the private/internal network
	export WAN=eth0
	export LAN=eth1

	# Enable IP forwarding and Masquerade
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE

	# Allow already established or related traffic WAN<->LAN
	iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

	# Allow new connections LAN->WAN
	iptables -A FORWARD -i $LAN -o $WAN -m state --state NEW -j ACCEPT

	# Allow ICMP ping LAN->WAN
	iptables -A FORWARD -i $LAN -o $WAN -p icmp --icmp-type echo-request -m state --state NEW -j ACCEPT

	# Allow connecting to servers WAN->LAN
	iptables -A FORWARD -i $WAN -o $LAN -m state --state NEW -p tcp --dport 22 -j ACCEPT
	iptables -t nat -A PREROUTING -i $WAN -m state --state NEW -p tcp --dport 2222 -j DNAT --to 192.168.1.2:22

	#==== Make changes persistent ==============================

	/etc/init.d/iptables save
	#Note: Remember to add the line "net.ipv4.ip_forward = 1" to /etc/sysctl.conf file.


	#==== Show rules ===========================================

	echo === FILTER =========================================
	echo
	iptables -L -n -v
	echo
	echo ==== NAT ===========================================
	echo
	iptables -L -n -v -t nat


## Desactivar IPtables (aceptar todo)

	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -F
	iptables -X
	iptables -F -t nat
	iptables -X -t nat
