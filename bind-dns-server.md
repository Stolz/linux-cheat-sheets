Servidor DNS [BIND](https://www.isc.org/software/bind)
===================

Instalación
-----------

Instalar en Gentoo

	emerge net-dns/bind

Activar el uso de jaula chroot (más seguro)

	$EDITOR /etc/conf.d/named

Descomentar la línea

	CHROOT="/chroot/dns"

Crear el director de la jaula

	emerge --config '=net-dns/bind-9.9.1_p4'

(reemplazar 9.9.1_p4 por el valor de la version que hayas instalado)


Configuración
-------------

Contenido de /etc/bind/named.conf

	options {
			// Rutas
			directory "/var/bind";
			pid-file "/var/run/named/named.pid";

			// Si estas detras de un firewall y experimentas problemas descomenta la siguiente linea
			//query-source address * port 53;

			// Escuchar en todas las interfaces IPv4
			listen-on-v6 { none; };
			listen-on { any; };

			// Solo permitimos consultar/usar la cache/hacer recursion a los ordenadores que estan en las mismas redes que el servidor
			allow-query { localnets; };
			allow-query-cache { localnets; };
			allow-recursion { localnets; };

			// No permitir transferencias/actualizaciones
			allow-transfer { none; };
			allow-update { none; };

			// Si no somos capaces de resolver lo trasladamos a otro servidor
			//forward first;
			forwarders {
					62.81.16.213;   // ONO principal
					62.81.16.148;   // ONO secundario
					8.8.8.8;        // Google Open DNS
					8.8.4.4;        // Google Open DNS
			};

			// Puesto que no tenemos servidores secunadarios no es necesario notificar cambios
			notify no;
	};

	// Vista Interna para la red local
	view "internal" {
			match-clients { 192.168.0.0/24; 172.16.0.0/24; 127.0.0.0/31; };
			recursion yes;
			include "/etc/bind/parte_comun.conf";

			zone "example.com" IN {
					type master;
					file "pri/example.com.zone.internal";
			};
	};

	// Vista externa
	view "external" {
			// Desactivado pq ya no se usa desde fuera match-clients { any; };
			match-clients { none; };
			// Para evitar que abusen de nuestro DNS para hacer consultas externas
			allow-recursion{ none; };
			recursion no;
			include "/etc/bind/parte_comun.conf";

			zone "example.com" IN {
					type master;
					file "pri/example.com.zone";
			};
	};

Contenido de /etc/bind/parte_comun.conf

	// Para evitar que se hagan consultas de IPs privadas a los servidores de internet
	zone "10.IN-ADDR.ARPA" {type master;file "pri/RFC1918.zone";};
	zone "16.172.IN-ADDR.ARPA" {type master;file "pri/RFC1918.zone";};
	zone "31.172.IN-ADDR.ARPA" {type master;file "pri/RFC1918.zone";};
	zone "168.192.IN-ADDR.ARPA" {type master;file "pri/RFC1918.zone";};

	// Raiz y localhost
	zone "." IN {
			type hint;
			file "/var/bind/root.cache";
	};

	zone "localhost" IN {
			type master;
			file "pri/localhost.zone";
			allow-update { none; };
			notify no;
	};

	zone "127.in-addr.arpa" IN {
			type master;
			file "pri/127.zone";
			allow-update { none; };
			notify no;
	};

Contenido de /etc/bind/pri/127.zone

	$ORIGIN 127.in-addr.arpa.
	$TTL 1W
	@                       1D IN SOA       localhost. root.localhost. (
											2008122601      ; serial
											3H              ; refresh
											15M             ; retry
											1W              ; expiry
											1D )            ; minimum

	@                       1D IN NS        localhost.
	1.0.0                   1D IN PTR       localhost.

Contenido de /etc/bind/pri/localhost.zone

	$TTL 1W
	@       IN      SOA     localhost. root.localhost.  (
										2008122601 ; Serial
										28800      ; Refresh
										14400      ; Retry
										604800     ; Expire - 1 week
										86400 )    ; Minimum
	@               IN      NS      localhost.
	@               IN      A       127.0.0.1

	@               IN      AAAA    ::1

Contenido de /etc/bind/pri/RFC1918.zone.internal

	@ 10800 IN SOA <name-of-server>. <contact-email>. (
			1 3600 1200 604800 10800 )
	@ 10800 IN NS <name-of-server>.

Contenido de /etc/bind/pri/example.com.zone (Reemplazar 123.456.789.10 por la IP pública real)

	; Note: Suffixes 'M','H','D' or 'W', indicate a time-interval of minutes, hours, days and weeks respectively
	;------------------------------------------------------------------------------
	; Default TTL for every resource record without a specific TTL
	$TTL 7D
	;------------------------------------------------------------------------------
	; Start of Authority (SOA)
	@ IN SOA example.com. webmaster.example.com. (
			1    ; Serial  | Zone serial number: incremented when the zone file is modified, so the slave and secondary name servers know when the zone has been changed and should be reloaded.
			1W   ; Refresh | The number of seconds between update requests from secondary and slave name servers.
			1H   ; Retry   | The number of seconds the secondary or slave will wait before retrying when the last attempt has failed.
			15D  ; Expire  | The number of seconds a master or slave will wait before considering the data stale if it cannot reach the primary name server
			1W ) ; Negative Cache TTL
	;------------------------------------------------------------------------------
	; Resource records
	@        IN A          123.456.789.10
	@        IN NS         www
	@        IN MX 1       aspmx.l.google.com.
	@        IN MX 5       alt1.aspmx.l.google.com.
	@        IN MX 5       alt2.aspmx.l.google.com.
	@        IN MX 10      aspmx2.googlemail.com.
	@        IN MX 10      aspmx3.googlemail.com.
	www      IN A          123.456.789.10
	ftp      IN CNAME      www


Contenido de /etc/bind/pri/example.com.zone.internal

	Es similar a /etc/bind/pri/example.com.zone pero con IPs de LAN

Ejecución
---------

Antes de nada asegúrate de que los ficheros `/etc/bind/*.conf` y `/etc/bind/pri/*` pertenecen al usuario/grupo `named:named`.

Para comprobar si el fichero de configuración es correcto

	named-checkconf /etc/bind/named.conf

Para iniciarlo

	/etc/init.d/named start

Para que se inicie automáticamente al arrancar el ordenador

	rc-update add named default

Configuración de IPTables

	iptables -A INPUT -p udp --dport domain -m state --state NEW -j ACCEPT
	iptables -A INPUT -p tcp --dport domain -m state --state NEW -j ACCEPT
