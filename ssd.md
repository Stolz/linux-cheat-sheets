SSD en Linux
============

Consideraciones
---------------

Hay que asegurarse que la controladora de discos de la placa base no haga cuello de botella para nuestro disco. Estas son las velocidades que define el estándar según el tipo de controladora:

- SATA/150 = SATA 1.5Gb/s -> 192MB/s
- SATA II = SATA 2 = SATA/300 = SATA II/300 = SATA 3Gb/s -> 384MB/s
- SATA 600 = Serial ATA Revision 3.0 = SATA 6Gb/s -> 768MB/s

En mi caso, el Crucial M4 (firmware 002) tiene una velocidad de 415MB/s de lectura y 175Mb/s de escritura, por lo que necesito una controladora SATA 600.

Además, el soporte AHCI debe estar activado en el kernel(SATA_AHCI) y en la BIOS. Si tu placa base tiene algún tipo de cacheo de bus y en tu sistema vas a tener solo discos SSD, cambia el ajuste de la BIOS de `Write Through` a `Write Back`.


Tamaños de página y de borrado de bloque
----------------------------------------

Para alinear las particiones y el sistema de ficheros hay que conocer el tamaño de página (__Nand page size__) y el tamaño de borrado de bloque (__Nand erase block size__).

Para los modelos Crucial M4 son:

- Modelos __64GB__ y __128GB__: __4KB__ page size (4KB = 512 bytes)
- Modelos __256GB__ y __512GB__: __8KB__ page size (8KB = 1024 bytes)
- Todos tienen un __erase block size__ de 512KB (Este dato no está confirmado oficialmente)


Particionado
------------

Hay que particionar de forma que el sector de comienzo de cada partición sea múltiplo del tamaño de página (en bytes). No es necesario que también terminen en un múltiplo pero es recomendable que así sea para minimizar el número de sectores que se quedan entre dos particiones.

Para particionar usar este comando

	fdisk -u -c /dev/sda

La opción `-u` sirve para mostrar las unidades en sectores y la opción `-c` sirve para desactivar el modo de compatibilidad con DOS, lo cual hace que `fdisk` trate de, en la medida de lo posible, hacer que todas las particiones que creemos empiecen en un sector que es múltiplo de __2048__.

2048 (sectores) * 512 = 1048576 = 1MByte, que es divisible por 512, 1024, 4096, 131072 y 524288 bytes, lo cual hace que sea un valor adecuado para todas los tipos de SSD que hay ahora mismo en el mercado doméstico.


Puesto que este comportamiento de `fdisk` no es infalible, hay que hacer la comprobación a mano para asegurarse de que el valor sugerido para el comienzo de la partición es un múltiplo de 2048. Recuerda que los sectores se empiezan a contar desde 0 por lo que un valor de 2048 significa que en realidad la partición empieza en el sector 2049.

Para ver el resultado

	fdisk -u -c -l /dev/sda

Todos los números de la columna _Comienzo_ deben ser divisibles por 2048.


Sistema de ficheros
-------------------

Existen diversos sistemas de ficheros muy prometedores para SSD como por ejemplo Btrfs o NILFS pero parece que no son los suficientemente maduros aun por lo que me limitaré a usar Ext4, que también da muy buenos resultados.

Existen varios ajustes de Ext4 a considerar.

### Tamaño del strip

Hay que intentar que el sistema de ficheros quede alineado indicando el tamaño del strip. El valor a usar es el número de sectores de 4K que entran en el __erase block size__ de nuestro disco. Por ejemplo, para un erase block size de 512K: 512K/4K = 128.

El comando para crear el sistema de ficheros sería:

	mkfs.ext4 -E stride=128,stripe-width=128 [...] /dev/sdaX

Si ya estaba creado entonces usar el comando `tune2fs` con los mismos parámetros (el sistema de ficheros debe estar desmontado).


### Journaling

Ext4 tiene activado el diario de transacciones o _journaling_ por defecto. El _journaling_ guarda información sobre los cambios que se realizan en el sistema de ficheros antes de que estos cambios se produzcan de forma que en caso de fallo del sistema o de energía es posible recuperar los datos. El problema es que el journaling realiza escrituras constantes en el disco, lo cual acorta la vida útil del disco SSD y reduce ligeramente su rendimiento.

Tenemos la posibilidad de desactivar el _journaling_ pero entonces __un reinicio inesperado puede causar que el sistema de ficheros se corrompa__. Es decisión nuestra tener un sistema más lento pero más fiable o más rápido pero menos fiable en caso de fallos.

Para desactivar el _journaling_ al crear el sistema de ficheros:

	mkfs.ext4 -O ^has_journal [...] /dev/sdaX

Si ya estaba creado entonces usar el comando `tune2fs` con los mismos parámetros (el sistema de ficheros debe estar desmontado).

Si no queremos desactivar el _journaling_, otra opción con menor penalización del rendimiento es usar __data=writeback__. Esta opción hace que los datos sean escritos en el sistema de ficheros tras escribir los metadatos de del _journaling_ (el comportamiento por defecto __data=ordered__ es es el contrario, los datos se escriben antes que los metadatos). Usando data=writeback __un reinicio inesperado puede causar pérdida de los últimos cambios realizados__ en los ficheros abiertos, pero no que el sistema de ficheros se corrompa.

Para activar data=writeback, el sistema de ficheros debe haber sido creado con _journaling_ (por defecto así es en ext4) y luego, estando desmontado, hay que ejecutar:

	tune2fs -o journal_data_writeback [...] /dev/sdaX

Además, añadir a `/etc/fstab` la opción __data=writeback__ a las particiones del SSD.

### TRIM

El kernel solporta __TRIM__ desde la versión 2.6.33. Para ver si nuestro disco lo soporta ejecutar

	hdparm -I /dev/sda

Deberíamos tener una línea así (incluido el asterisco)

	* Data Set Management TRIM supported

Para activar el soporte trim en Ext4 hay que añadir a `/etc/fstab` la opción __discard__ a las particiones del SSD.

Para hacer uso de __discard__ desde el momento en en que creamos el sistema de ficheros ejecutar:

	mkfs.ext4 -E discard [...] /dev/sdaX

Podemos hacer que el sistema se monte con esta opción por defecto ejecutarndo (el sistema de ficheros debe estar desmontado)

	tune2fs -o discard [...] /dev/sdaX


Para saber si TRIM esta funcionando, estudiar los mensajes tras ejecutar

	dmesg | grep -i discard

Si sale algo como _discard not supported_ entonces TRIM está fallando.

### noatime

Otra práctica útil para reducir aun más las escrituras es desactivar el registro de los tiempos de acceso de los archivos y directorios añadiendo a `/etc/fstab` las opciones __noatime,nodiratime__.

### barrier

Otro ajuste que aumenta el rendimiento es montar con la opción __nobarrier__ ( o equivalentemente barrier=0). Algo totalmente desaconsejado si tu sistema no tiene algún tipo de batería o S.A.I.


### Otros ajustes

Resumen de lo que suelo usar

	mkfs.ext4 -E discard -j -L gentoo -m 0 -O dir_index,has_journal /dev/sdaX
	tune2fs -c 300 -e remount-ro -i 3m -j -L gentoo -m 0 -o journal_data_writeback,nobarrier,discard,commit=900 -O dir_index,has_journal /dev/sdaX

### Comprobación final


Por último comprobar que el sistema se ha creado correctamente ...

	e2fsck -f /dev/sdaX
	
... y que las opciones que hemos indicado se han gaurdado en el sistema de ficheros

	tune2fs -l /dev/sdaX

Si tenemos problemas para montar la unidad en modo escritura en sistemas 32 bits activar la siguiente opción

	Enable the block layer
		Support for large (2TB+) block devices and files (LBDAF)



Un último consejo: se recomienda no llenar los sistema de ficheros por encima del 75% de capacidad para asegurar al kernel la máxima eficacia de uso.


Planificador de disco
---------------------

El planificador (_I/O scheduler_ en el kernel) `cfq` es recomendable para discos tradicionales pero no lo es para discos SSD. Los recomendados para SSD son `noop` o `deadline`. Si se van a tener discos convencionales junto a los SSD no se es recomendable cambiar todo el sistema a noop. Se puede indicar por separado así:

	echo noop > /sys/block/sdX/queue/scheduler
	echo cfq > /sys/block/sdY/queue/scheduler
	echo deadline > /sys/block/sdZ/queue/scheduler

En cualquier caso, cfq comprueba si el disco es rotacional o no y si no lo es cambia su comportamiento para que sea adecuado para SSD.

Para comprobar cual esta activado ejecutar

	cat /sys/block/sdX/queue/scheduler


hdparm
------

Para los discos SSD usar este ajuste

	hdparm -W1 /dev/sdaX

Para los discos convencionales usar

	hdparm -W0 /dev/sda

En Gentoo estos ajsutes se pueden hacer permanentes en `/etc/conf.d/hdparm`


Memoria de intercambio SWAP
---------------------------

La memoria SWAP se guarda en disco, lo cual implica muchas escrituras. Con el precio actual de la RAM (16GB DDR3 80€) se recomienda desactivar totalmente la swap en el kernel y en `/etc/fstab`.


Montar en RAM
-------------

Otra forma de de aumentar el rendimiento y evitar las escrituras en disco es usar un disco en la memoria RAM usando Tmpfs.

Tmpfs es un sistema de ficheros que guarda todos los archivos en la memoria virtual (RAM) en vez de en el disco duro. Si se desmonta, todo lo almacenado en él se pierde. El tamaño aumenta o disminuye dinámicamente para adaptarse a los archivos que contiene. Si crece por encima del tamaño físico de nuestra RAM puede empezar a usar SWAP por lo que conviene establecerle un límite con la opción __size__ en `/etc/fstab`. Si no guardamos nada en él, no ocupa RAM.

Una buena práctica para discos SSD es montar en tmpfs todo lo que sea prescindible y realice escrituras constantes, por ejemplo __/tmp /usr/tmp /var/tmp ~/.kde4/tmp-$HOSTNAME y /var/log__. Por ejemplo

	none	/tmp	tmpfs	nodev,nosuid,noatime,size=1000M,mode=1777	0	0

Una forma sencilla y rápida para no tener que añadir las entradas a `/etc/fstab` es hacer que esas rutas sean enlaces simbólicos que apunten a /dev/shm.

En Gentoo por defecto ya tenemos un sistema tmpfs creado en /dev/shm. Así es como luce mi `/etc/fstab` (tengo 16GB de RAM)

	shm /dev/shm tmpfs nodev,nosuid,noexec,noatime,nodiratime,size=14G 0 0

Podemos cambiar el tamaño al vuelo

	mount -o remount,size=4G /dev/shm


El valor por defecto de `PORTAGE_TMPDIR` apunta a /var/tmp (se puede cambiar en `/etc/make.conf`) por lo que si esa ruta ya está montada en RAM (o es un enlace a /dev/shm) no hace falta indicar nada para que Portage lo use. Lo que sí es útil es añadir la opción `--fail-clean=y` a la variable `EMERGE_DEFAULT_OPTS` de `/etc/make.conf` para que se borren los temporales tras una compilación fallida.


Firefox
-------

Mover la cache de Firefox a RAM:

	about:config -> new -> browser.cache.disk.parent_directory -> /dev/shm

Otra opción es desactivar la cache

	about:config -> browser.cache.disk.enable -> false

Para verificar la cache:

	about:cache

Desactivar el sistema de restaurado de sesiones en caso de fallo (ya que escribe constantemente en disco)

	about:config -> browser.sessionstore.enabled -> false


Secure erase
------------

Sirve para borrar todos los datos y recuperar algo de rendimiento.

	hdparm --user-master u --security-set-pass PASSWORD /dev/sdc
	hdparm --user-master u --security-erase PASSWORD /dev/sdc

reemplazar PASSWORD por una contraseña real.
