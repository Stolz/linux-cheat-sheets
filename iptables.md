# netfilter/iptables por la via rápida

###  Instalación en Gentoo

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

	Networking  --->
	[*] Networking support
		Networking options  --->
		[*] Network packet filtering framework (Netfilter)  --->
			Core Netfilter Configuration  --->
			<M> Netfilter Xtables support (required for ip_tables)
			IP: Netfilter Configuration  --->
			<M> IP tables support (required for filtering/masq/NAT)
			<M>   Packet filtering

Con esta configuración mínima podremos hacer reglas básicas con un aspecto similar a este:

	iptables -A INPUT -p tcp --sport http  -j ACCEPT

### Relacionar paquetes con conexiones

Si además queremos poder hacer un seguimiento de los paquetes que han pasado por el ordenador para saber cuales son consecuencia de las conexiones que hemos realizado o si queremos utilizar el estado de una conexión (INVALID, ESTABLISHED, NEW, RELATED) como condición en una regla, entonces debemos de añadir la siguiente opción:

	Networking  --->
		[*] Networking support
			Networking options  --->
			[*] Network packet filtering framework (Netfilter)  --->
				Core Netfilter Configuration  --->
				<M> Netfilter connection tracking support

Lo cual hace que a aparezcan nuevas opciones de las cuales debemos marcar las siguientes:

				Core Netfilter Configuration  --->
				<M>   "state" match support
				IP: Netfilter Configuration  --->
				<M> IPv4 connection tracking support (required for NAT)

Con esta configuración podremos hacer reglas con un aspecto similar a este:

	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

###  Rangos de puertos

Para poder indicar rangos de puertos en una regla no es necesario activar nada, con separarlos por `:` es suficiente. Por ejemplo:

	iptables -A INPUT -p tcp --sport 500:550  -j ACCEPT

Pero para poder indicar una lista de puertos no consecutivos tenemos que añadir una nueva opción:

	Networking  --->
	[*] Networking support
		Networking options  --->
		[*] Network packet filtering framework (Netfilter)  --->
			Core Netfilter Configuration  --->
			[*]   Advanced netfilter configuration

Lo cual hace que a aparezcan nuevas opciones de las cuales debemos marcar las siguientes:

			Core Netfilter Configuration  --->
			<M>   "multiport" Multiple port match support

Con esta configuración podremos hacer reglas con un aspecto similar a este:

	iptables -A INPUT -p tcp -m multiport --sport http,https  -j ACCEPT

__NOTA:__ Con esta sintaxis es en algunos servidores algunos puertos aletorios a veces no se abren (comprobado con nmap), pero en cambio con esta otra sintaxis si van:

	iptables -A INPUT -p tcp --match multiport --dports http,https -m state --state NEW -j ACCEPT


### Dejar constancia de los paquetes en el syslog

Podemos usar la función LOG de iptables para saber qué paquetes se están filtrando. Esta función es útil por ejemplo para saber qué intentos de ataque ha sufrido nuestra máquina o qué uso se intenta hacer de la red. Tambiés es útil para conocer los puertos  que usa algún programa poco común el cual hemos observado que deja de funcionar con el firewall activado. Para disponer de esta función de iptables tenemos que añadir una nueva opción:

	Networking  --->
	[*] Networking support
		Networking options  --->
		[*] Network packet filtering framework (Netfilter)  --->
			IP: Netfilter Configuration  --->
			<M>   LOG target support

Con esta configuración podremos hacer reglas con un aspecto similar a este:

	iptables -A INPUT -j LOG --log-level 2 --log-prefix "Firewall: "

Si además quieres que no se llene el log puedes usar el modulo limit para limitar cuanta informacion se guarda. Para activarlo hacer lo mismo que en c) pero en el ultimo paso marcar

			<M>   "limit" match support

Con lo que la regla con el límite aplicado quedaría:

	iptables -A INPUT -m limit --limit 3/minute --limit-burst 3 -j LOG --log-level 2 --log-prefix "Firewall: "

###  Redireccion de puertos a otro ordenador:

Añadir al kernel soporte para NAT y MASQUERADE

	Networking  --->
	[*] Networking support
		Networking options  --->
		[*] Network packet filtering framework (Netfilter)  --->
			IP: Netfilter Configuration  --->
			<M>   Full NAT
			<M>    MASQUERADE target support

Añadir a las reglas de limpiado la tabla NAT

	iptables -F -t nat
	iptables -X -t nat


Cambiar la politica por defecto de FORWARD a

	iptables -P FORWARD ACCEPT

Ejemplo: Redireccionar el puerto 1111 al puerto 2222 de la IP 172.16.0.98

	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A PREROUTING -p tcp -m tcp --dport 1111 -j DNAT --to-destination 172.16.0.98:2222
	iptables -t nat -A POSTROUTING -j MASQUERADE


## Ejemplo de configuración


	# Limpiar todas las reglas y cadenas existentes
	iptables -F
	iptables -X
	# Si además tienes IP forwarding activado (echo 1 > /proc/sys/net/ipv4/ip_forward)
	#iptables -F -t nat
	#iptables -X -t nat

	# Politica por defecto si un paquete no corresponde a ninguna de las reglas que definiremos luego:
	#  - Rechazar todo lo que entre para nosotros
	#  - Rechazar todo lo que entre para otros
	#  - Aceptar todo lo que salga de nosotros
	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT ACCEPT

	# ------ REGLAS ---------------------------------------------------------------
	# Para un ordenador cliente que no tenga programas a la escucha de conexiones
	# debería ser suficiente con indicar esta regla:

	# Aceptar todas las conexiones entrantes que sean consecuencia de nuestras conexiones salientes
	#iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	# Pero para un ordenador servidor deberemos de añadir reglas para permitir el acceso a los diferentes
	# servicios que ofrezca. A continuación pongo algunas de las reglas típicas, descoméntalas según te convenga.
	# NOTA: Si en el caso del ordenador servidor decides usar la regla explicada para el ordenador cliente
	# muchas (por no decir todas) las reglas de tipo "Aceptar respuestas" que vienen a continuación se pueden
	# omitir pues ya están incluidas en dicha regla.

	echo loopback
	# ===========
	# Aceptar la entrada de todo lo que provenga de la interfaz loopback (lo)
	iptables -A INPUT -i lo -j ACCEPT


	echo ping ICMP
	# ============
	# Aceptar respuestas
	#iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
	# Aceptar peticiones
	#iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT


	echo DNS
	# ======
	# Aceptar respuestas
	#iptables -A INPUT -p udp --sport domain -j ACCEPT
	# Aceptar conexiones
	#iptables -A INPUT -p udp --dport domain -m state --state NEW -j ACCEPT


	echo HTTP y HTTPs
	# ===============
	# Aceptar respuestas
	#iptables -A INPUT -p tcp -m multiport --sport http,https -j ACCEPT
	# Aceptar conexiones
	#iptables -A INPUT -p tcp -m multiport --dport http,https -m state --state NEW -j ACCEPT


	echo SSH
	# ======
	# Aceptar respuestas
	#iptables -A INPUT -p tcp --sport ssh -j ACCEPT
	# Aceptar conexiones
	#iptables -A INPUT -p tcp --dport ssh -m state --state NEW -j ACCEPT


	echo NTP
	# ======
	# Aceptar respuestas
	#iptables -A INPUT -p udp --sport ntp -j ACCEPT
	# Aceptar peticiones
	#iptables -A INPUT -p udp --sport ntp -m state --state NEW -j ACCEPT


	echo POP3 y POP3s
	# ===============
	# Aceptar respuestas
	#iptables -A INPUT -p tcp -m multiport --sport pop3,pop3s -j ACCEPT
	# Aceptar conexiones
	#iptables -A INPUT -p tcp -m multiport --sport pop3,pop3s -m state --state NEW -j ACCEPT


	echo SMTP
	# =======
	# Aceptar respuestas
	#iptables -A INPUT -p tcp --sport smtp -j ACCEPT
	# Aceptar peticiones
	#iptables -A INPUT -p tcp --dport smtp -m state --state NEW -j ACCEPT


	echo FTP
	# ======
	# Aceptar peticiones
	#iptables -A INPUT -p tcp --dport ftp -m state --state NEW -j ACCEPT
	#Conexiones pasivas
	#iptables -A INPUT -p tcp --dport 2690:2695 -m state --state NEW -j ACCEPT


	echo RSYNC
	# ========
	# Aceptar respuestas
	#iptables -A INPUT -p tcp --sport rsync -j ACCEPT
	# Aceptar peticiones
	#iptables -A INPUT -p tcp --dport rsync -m state --state NEW -j ACCEPT


	echo MySQL
	# ========
	# Aceptar respuestas
	#iptables -A INPUT -p tcp --sport mysql -j ACCEPT
	# Aceptar peticiones
	#iptables -A INPUT -p tcp --dport mysql -m state --state NEW -j ACCEPT


	echo NFS
	# =======
	# Aceptar respuestas
	# Aceptar peticiones
	#...Portmap
	#iptables -A INPUT -p tcp --dport 111 -j ACCEPT
	#iptables -A INPUT -p udp --dport 111 -j ACCEPT
	#...NFS
	#iptables -A INPUT -p tcp --dport 2049 -j ACCEPT
	#iptables -A INPUT -p udp --dport 2049 -j ACCEPT
	#...nlockmgr (modulo lockd)
	#iptables -A INPUT -p tcp --dport 4001 -j ACCEPT
	#iptables -A INPUT -p udp --dport 4001 -j ACCEPT
	#...status y mountd
	#iptables -A INPUT -p tcp --dport 32764:32767 -j ACCEPT
	#iptables -A INPUT -p udp --dport 32764:32767 -j ACCEPT


	echo SAMBA
	# ========
	# Aceptar respuestas
	# Aceptar peticiones
	#iptables -A INPUT -p udp --dport 137:138 -m state --state NEW -j ACCEPT
	#iptables -A INPUT -p tcp --dport 139 -m state --state NEW -j ACCEPT
	# Activar la siguiente solo si usamos 'Microsoft Active Directory'
	#iptables -A INPUT -p tcp --dport 445  -m state --state NEW-j ACCEPT


	echo Distcc
	# =========
	#Para el servidor
	iptables -A INPUT -p tcp --dport 3632 -m state --state NEW -j ACCEPT
	#Si usas Avahi (zeroconf) para descubrir máquinas disponibles
	iptables -A INPUT -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT


	echo MSN
	# ======
	# Permitir iniciar sesión de MSN
	#iptables -A INPUT -p tcp --sport 1863 -j ACCEPT

	echo SVN
	# ======
	# Aceptar conexiones
	iptables -A INPUT -p udp --dport svn -m state --state NEW -j ACCEPT
	iptables -A INPUT -p tcp --dport svn -m state --state NEW -j ACCEPT


	echo NO-IP.org
	# ============
	# Permitir respuestas del cliente no-ip.org
	#iptables -A INPUT -p tcp --sport 8245 -j ACCEPT


	echo aMule
	# ========
	# Permitir conexiones a la red Edonkey
	#iptables -A INPUT -p tcp --dport 4662 -j ACCEPT
	#iptables -A INPUT -p udp -m multiport --dport 4665,4672 -j ACCEPT


	echo TeamSpeak
	# ============
	# Permitir conexiones
	#iptables -A INPUT -p udp --dport 8767 -j ACCEPT


	#echo Ventrilo
	# ===========
	#iptables -A INPUT -p tcp --dport 3784 -m state --state NEW -j ACCEPT
	#iptables -A INPUT -p udp --dport 3784 -m state --state NEW -j ACCEPT


	#echo Murmur (Mumble)
	# ================
	#iptables -A INPUT -p tcp --dport 64738 -m state --state NEW -j ACCEPT
	#iptables -A INPUT -p udp --dport 64738 -m state --state NEW -j ACCEPT


	echo Denegar acceso
	# =================
	# Denegar el acceso a todos los servicios a una determinada IP
	#iptables -I INPUT 1 -s 11.22.33.44 -j DROP


	echo Log de rechazados
	# ====================
	#Creamos una nueva tabla que se encarga de registrarlos en el log todos los paquetes que llegana ella y luego los descarta
	iptables -N LOGDROP
	iptables -A LOGDROP -m limit --limit 3/minute --limit-burst 3 -j LOG --log-level 2 --log-prefix "Firewall: "
	iptables -A LOGDROP -j DROP
	#Todos los paquetes que no hayan concididos con alguna de las reglas anteriores y llegen hasta aqui, los enviamos a la nueva tabla
	iptables -A INPUT -j LOGDROP


	echo
	echo Guardando reglas....
	/etc/init.d/iptables save
	echo

	echo =====Puertos ========================================================
	iptables -L -n
	echo ==== Redirecciones ==================================================
	iptables -L -t nat -n


## Desactivar IPtables (aceptar todo)

	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -F
	iptables -X
	# Si además tienes IP forwarding activado (echo 1 > /proc/sys/net/ipv4/ip_forward)
	#iptables -F -t nat
	#iptables -X -t nat
