# Intalar Gentoo en Android mediante chroot

Este documento explica cómo podemos ejecutar Gentoo en Android mediante el método chroot (jaula). Todo el proceso de instalación y configuración de Gentoo se realiza en el ordenador, es decir, no hace falta compilar nada en el dispositivo Android (aunque si se quiere, se puede).

Para instalar y compilar descargaremos un stage3 y haremos una instalación normal de Gentoo usando el emulador Qemu. Cuando Gentoo esté instalado y configurado lo copiaremos al dispositivo Android y lo ejecutaremos desde ahí.

## Requisitos previos

- Tener acceso root al dispositivo Android.
- Tener instaladas las "platform-tools" del SDK de Android.
- Tener instalada en el dispositivo Android una copia funcional de busybox.
- Conocimientos para hacer una instalación estándar de Gentoo.
- Al menos 1GB de espacio en la tarjeta SD.

Además, se da por hecho que:

- El comando `adb` de las "platform-tools" está añadido al $PATH del usuario.
- El comando `busybox` está añadido al $PATH del dispositivo Android.
- El dispositivo Android tiene la depuración USB activada y está conectado por cable al ordenador.
- La shell activa tiene exportada la variable **$CHROOT** que contiene la ruta absoluta de nuestro ordenador que contendrá la nueva instalación de Gentoo.

## Descripción general del método

El método chroot o jaula consiste en iniciar nuestro dispositivo Android de forma normal y luego lanzar Gentoo desde Android.

La principal ventaja de este método es que al usar el kernel original de nuestro dispositivo tenemos soporte para todo el hardware instalado (Wifi, Bluetooth, GPS, ...). En teoria sería posible compilar nuestro propio kernel de Android desde Gentoo pero debido a que los fabricantes no suelen liberar  los drivers de sus dispositivos perderíamos el soporte para gran parte del hardware.

Otra ventaja es que no se altera el sistema original Android. Los dos sistemas pueden convivir y ejecutarse a la vez. No obstante, si se desea se pueden detener de forma fácil todos los procesos y servicios de Android que no esten destinados a dar soporte de harware para así tener más memoria disponible para Gentoo. Una vez detenido el chroot Gentoo los servicios de android son restaurados y se puede seguir usando el dispositivo con la interfaz Android.

La desventaja de este método es que al no iniciar Gentoo mediante `/sbin/init` no tenemos disponibles todas las caracteríasticas de OpenRC y los servicios tienen que ser iniciados a mano.

Como se ha mencionado, toda la compilación se hace en el ordenador personal gracias al emulador Qemu. No obstante, es posible compilar directamente desde el dispositivo Android aunque por razones obvias es algo totalmente desaconsejable.

## Obtener el stage3

Hay que descargar el stage3 correcto para la arquitectura de tu dispositivo Android. Para averiguar la arquitectura ejecuta:

	adb shell "busybox uname -a;busybox cat /proc/cpuinfo"

El proceso para determinar el stage3 adecuado es similar a cuando lo hacemos para instalar Gentoo en nuestro ordenador. Google es tu amigo.

En mi caso necesito el stage3 para ARM v7 hard-float (hardfp) que se encuentran en el directorio `releases/arm/autobuilds` de los [mirrors oficiales](http://www.gentoo.org/main/en/mirrors2.xml). Si tu caso es distinto tendrás que ajustar el nombre del stage3, el valor de la variable `QEMU_USER_TARGETS` en la configuración de Qemu y las variables CHOST y CFLAGS de _make.conf_ para que se adapten a tu arquitectura.

Para descagar y descomprimir el stage3:

	mkdir -p $CHROOT && cd $CHROOT
	wget http://distfiles.gentoo.org/releases/arm/autobuilds/current-stage3-armv7a_hardfp/stage3-armv7a_hardfp-FECHA.tar.bz2
	tar xvf stage3-armv7a_hardfp-FECHA.tar.bz2 --bzip2
	mkdir -p usr/portage distfiles dev/pts
	cp /etc/resolv.conf etc/

Si lo deseas puedes borrar el archivo del stage3 una vez descomprimido.

## Instalar Qemu

Recompilar el kernel con `CONFIG_BINFMT_MISC=m` y reiniciar. Después instalar qemu-user

	echo "QEMU_USER_TARGETS=arm" >> /etc/portage/make.conf
	emerge app-emulation/qemu-user

Recuerda asignar un valor a `QEMU_USER_TARGETS` acorde con la arquitectura de tu dispositivo Android. Si tienes problemas para compilar qemu-user prueba usando la versión 4.13-r2 de `sys-apps/texinfo`.

Edita `/etc/init.d/qemu-binfmt` y en la sección *"register the interpreter for each cpu except for the native on"* elimina o comenta todos los bloques *"if..fi"* exceptuando el que hace referencia a la arquitectura de tu dispositivo Android (en mi caso `qemu-static-arm-binfmt`). Esto es necesario porque al asignar la variable `QEMU_USER_TARGETS` solo hemos compilado soporte para este intérprete que es el único que necesitamos. Si no borramos el resto al intentar lanzar el servicio qemu-binfmt dará fallo.

Una vez hecho el cambio para poder usar el intérprete qemu para arm en nuestro host solo hay que ejecutar

	/etc/init.d/qemu-binfmt start

Por último necesitamos copiar el intérprete qemu a nuestra jaula

	cp -v /usr/bin/qemu-static-arm* $CHROOT/usr/bin/

## Entrar en la jaula Qemu

Para automatizar el proceso crear el script `/sbin/chroot-qemu-android.sh` con el siguiente contenido (recuerda modificar la variable CHROOT acorde a tu caso).

	#!/bin/bash
	if [[ $EUID -ne 0 ]]; then
		echo "This script must be run as root"
		exit 1
	fi

	export CHROOT=/mnt/lineal/chroot/arm

	#Iniciar Qemu
	[[ -f /proc/sys/fs/binfmt_misc/arm ]] || /etc/init.d/qemu-binfmt restart

	#Montar
	for x in dev dev/pts proc sys tmp usr/portage; do
		grep -qs "$CHROOT/$x " /proc/mounts || mount --bind /$x $CHROOT/$x
	done

	#Si usas un $DISTDIR no estandar
	grep -qs "$CHROOT/distfiles "   /proc/mounts || mount --bind /mnt/lineal/distfiles $CHROOT/distfiles

	#Entrar en la jaula
	chroot $CHROOT /bin/bash --login

	#Desmontar
	cd /
	pidof qemu-static-arm || umount $CHROOT/distfiles $CHROOT/usr/portage $CHROOT/tmp $CHROOT/sys $CHROOT/proc $CHROOT/dev/pts $CHROOT/dev

## Instalación de Gentoo

Entrar en la jaula Qemu

	chroot-qemu-android.sh
	env-update
	source /etc/profile
	export "PS1=(chroot qemu) $PS1"

Seguir el proceso de instalación estándar de Gentoo para la arquitectura de tu dispositivo Android. Pon especial atención a las variables de compilación de make.conf. En mi caso he usado:

	CHOST="armv7a-hardfloat-linux-gnueabi"
	CFLAGS="-O2 -pipe -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard" # + INFO: http://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
	CXXFLAGS="${CFLAGS}"
	FEATURES="-userfetch noman noinfo nodoc parallel-fetch unmerge-orphans fixlafiles parallel-install"

Antes de instalar nada recuerda elegir un perfil adecuado. En mi caso

	eselect profile set default/linux/arm/13.0/armv7a

Usa el comando `emerge` para instalar todo que quieras pero no olvides instalar dhcpcd, busybox y dropbear

	USE="static" emerge busybox
	emerge dropbear dhcpcd
	mkdir -p /etc/dropbear/
	/usr/bin/dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
	/usr/bin/dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key

No olvides asignar contraseña al usuario root dentro del chroot.

	passwd

## Preparar la tarjeta SD

El siguiente paso es dar formato a la tarjeta SD. En mi caso lo voy a hacer desde Android pero lo puedes hacer desde el ordenador.

**¡Advertencia: Esto borrará totalmente la tarjeta SD!**

	adb shell
	busybox umount /mnt/sdcard
	busybox umount /dev/block/mmcblk0p5
	busybox mkfs.ext3 -m0 /dev/block/mmcblk0p5
	mkdir -p /mnt/sdcard
	busybox mount /dev/block/mmcblk0p5 /mnt/sdcard

Reemplaza `/dev/block/mmcblk0p5` por la ruta de la partición de tu tarjeta SD. Puedes intentar localizar la partición de tu SD en Android con este comando

	adb shell "busybox cat /proc/partitions;mount"

Si la ROM de tu dispositivo Android soporta ext4 es recomendable usarlo en vez de ext3.

## Copiar Gentoo a la tarjeta SD

Se tiene que copiar el contenido de $CHROOT a la tarjeta SD. En mi caso en vez de copiar todo a la raiz de la tarjeta SD lo voy a copiar a una subcarpeta "gentoo" para poder seguir usando la tarjeta SD desde Android sin interferir con Gentoo.

Tienes varias formas de hacerlo. Puedes montar la tarjeta SD en tu ordenador y copiarlo desde ahí (conservando permisos) o puedes copiarlo por red.

Una vez copiado debes buscar la forma que más te convenga para mantener sincronizadas las copias del ordenador y las del dispositivo Android.

Una opción es añadir `FEATURES="buildpkg"` en el make.conf de la jaula Qemu y luego instalar en Android usando `emerge -K`, pero ello implicaría tener montado por red $PKGDIR y $PORTDIR en Android.

Si no tienes problemas de espacio en tu SD (El sistema básico de Gentoo, sin Portage pero con todas las dependencias para poder compilar es de menos de 1GB) mi consejo es que uses el comando rsync para mantener ambas versiones sincronizadas por SSH.

	rsync $CHROOT root@tablet:/mnt/sdcard/gentoo/ --recursive --archive --human-readable --delete --progress --stats \
	--exclude /dev/* \
	--exclude /proc/* \
	--exclude /sys/* \
	--exclude /tmp/* \
	--exclude /run/* \
	--exclude usr/portage/* \
	--exclude var/tmp/* \
	--exclude distfiles/ \
	--exclude usr/share/doc \
	--exclude usr/share/gtk-doc \
	--exclude usr/share/info \
	--exclude usr/share/man

## Iniciar Gentoo en Android

Para automatizar el proceso crear el script `$CHOST/gentoo.sh` con el siguiente contenido (recuerda modificar las variables $device, $mount_point y $chroot_dir acorde a tu caso).

	# Config
	export device=/dev/block/mmcblk0p5 #what to mount
	export mount_point=/mnt/sdcard #where to mount it
	export chroot_dir=$mount_point/gentoo #chroot destination

	error_exit() {
		echo ---------------
		echo "Error: $1"
		echo ---------------
		exit 1
	}

	mount -o rw,remount /system || error_exit "Unable to mount /system rw"

	# Mount SD card
	mount -o rw,remount /system
	mkdir -p "$mount_point"
	busybox grep -qs "$mount_point " /proc/mounts || busybox mount $device $mount_point || error_exit "Unable to mount $device on $mount_point"

	# Look for chroot dir
	[ -d "$chroot_dir" ] || error_exit "Unable to find chroot dir at $chroot_dir"
	mkdir -p "$chroot_dir/sdcard"

	# Use our own busybox (Android Market's ones are buggy!)
	[ -f "$chroot_dir/bin/busybox" ] || error_exit "Unable to find custom busybox at $chroot_dir/bin/busybox"
	[ -x "$chroot_dir/bin/busybox" ] || error_exit "Custom $chroot_dir/bin/busybox is not executable"
	unalias b
	alias b="$chroot_dir/bin/busybox"

	# Copy mounts to chroot
	b grep -v rootfs /proc/mounts > "$chroot_dir/etc/mtab"

	# Mount all required partitions
	b grep -qs "$chroot_dir/dev " /proc/mounts     || b mount -o bind /dev "$chroot_dir/dev"         || error_exit "Unable to bind $chroot_dir/dev"
	b grep -qs "$chroot_dir/dev/pts " /proc/mounts || b mount -t devpts devpts "$chroot_dir/dev/pts" || error_exit "Unable to mount $chroot_dir/dev/pts"
	b grep -qs "$chroot_dir/proc " /proc/mounts    || b mount -t proc proc "$chroot_dir/proc"        || error_exit "Unable to mount $chroot_dir/proc"
	b grep -qs "$chroot_dir/sys " /proc/mounts     || b mount -t sysfs sysfs "$chroot_dir/sys"       || error_exit "Unable to mount $chroot_dir/sys"
	# b grep -qs "$chroot_dir/sdcard " /proc/mounts  || b mount -o bind /sdcard "$chroot_dir/sdcard"   || error_exit "Unable to bind $chroot_dir/sdcard"

	# Sets up network forwarding
	b sysctl -w net.ipv4.ip_forward=1 || error_exit "Unable to forward network"

	# Stop Zygote and all the Android services to have more RAM in our chroot
	stop

	# Chroot
	#b chroot $chroot_dir /bin/bash -l -c "/usr/sbin/env-update; source /etc/profile;bash"
	b chroot $chroot_dir /usr/bin/env -i HOME=/root USER=root PATH=/sbin:/bin:/usr/sbin:/usr/bin TERM=linux /bin/bash -l

	# Shut down chroot
	echo "Shutting down chroot"
	for pid in `b lsof | b grep -s $chroot_dir | b sed -e's/  / /g' | b cut -d' ' -f2`; do b kill -9 $pid >/dev/null 2>&1; done
	sleep 5

	# Restart Zygote
	start

	# b umount $chroot_dir/sdcard || echo "Error: Unable to umount $chroot_dir/sdcard"
	b umount $chroot_dir/sys      || echo "Error: Unable to umount $chroot_dir/sys"
	b umount $chroot_dir/proc     || echo "Error: Unable to umount $chroot_dir/proc"
	b umount $chroot_dir/dev/pts  || echo "Error: Unable to umount $chroot_dir/dev/pts"
	b umount $chroot_dir/dev      || echo "Error: Unable to umount $chroot_dir/dev"

----

**Si quieres poder seguir usando Android mientas ejecutas la jaula Gentoo elimina o comenta las lineas "stop" y "start". Esto hará que no se paren los servicios y programas Android, dejando menos memoria para Gentoo pero manteniendo ambos sistemas en ejecución a la vez.**

----

Para lanzar, por fin, la jaula Gentoo dentro de Android:

	adb remount
	adb push $CHOST/gentoo.sh /data/
	adb shell "netcfg;chmod 755 /data/gentoo.sh;/data/gentoo.sh"

Para no depender más del cable, una vez dentro lanzar el demonio SSHd

	dropbear

En este momento ya podemos desconectar el cable. Para conectar a nuesta jaula por SSH solo necesitamos conocer la IP del dispositivo Android que ha sido mostrada en el comando que lanza la jaula.

## Ejecutar Gentoo de forma permanente

Tras los pasos anteriores, cada vez que necesitemso iniciar Gentoo en nuestro dispositivo Android necesitamos conectar el cable y ejecutar

	adb shell /data/gentoo.sh

Para que Gentoo se inicie automáticamente al encender el dispositivo Android existen varias formas. Si la ROM Android que usas soporta `init.d` puedes crear el archivo `/system/etc/init.d/99gentoo-chroot` con el siguiente contenido

	/data/gentoo.sh

Si tu ROM no soporta `init.d` puedes instalarte cualquiera de las varias aplicaciones de gestión de scripts disponibles en el Market de Android.

Otra opción es modificar el fichero `/init.rc` para que ejecute `/data/gentoo.sh`. La forma de hacer esto depende de cada dispositivo pero en general implica modificar el _ramdisk_ original de tu dispositivo y reflashearlo mediante _fastboot_ o desde el _recovery_. Existe mucha información al respecto en [Xda-developers](http://forum.xda-developers.com/).

