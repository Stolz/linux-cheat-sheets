# Compilar Android

Pasos para compilar tu propia version de Cyanogen Mod 7 para el Nexus One.

[Licencia](LICENCIA.md)

## Instalar las herramientas para comunicarnos con el telefono por USB

### Descargar el SDK para linux

[Página de descarga](http://developer.android.com/sdk/index.html)

	wget http://dl.google.com/android/android-sdk_r10-linux_x86.tgz

### Descomprimir el archivo

	gzip -dc android-sdk_r10-linux_x86.tgz | tar xf -
	mv android-sdk-linux_x86 ~/android

### Ejecutar el actualizador para instalar las "Android SDK Platform-tools"

	~/android/tools/android

En `Available Packages->Android Repository` Marcar `Android SDK Platform-tools, revision X`. Pulsar el boton `Install selected` y aceptar la licencia. Tras acabar la instalación cerrar las ventanas.

### Dar permisos de lectura al dispositivo USB

	su
	echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e12", MODE="0600", OWNER="stolz"
	SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", ATTR{idProduct}=="0fff", MODE="0600", OWNER="javi"' > /etc/udev/rules.d/51-android.rules
	exit

### Activar el modo "Depuración USB" en el teléfono

`Ajustes > Aplicaciones > Desarrollo > Depuración USB)`, conectarlo al ordenador con el cable USB y comprobar que tenemos conexion

	~/android/platform-tools/adb devices

### Crear el entorno para construir Android

Paquetes necesarios:

- dev-lang/python (de serie en Gentoo)
- dev-vcs/git
- sys-process/schedtool
- =sys-devel/make-3.81 (la 3.82 parece que no va)
- ¿dev-java/sun-jdk 1.6 ? Comprobar la maquina java que estamos usando con java-config -L


### Instalar la herramienta "repo"

Nos ayudará a interactuar con git

	wget http://android.git.kernel.org/repo -O ~/android/tools/repo
	chmod 755 ~/android/tools/repo

### Configurar Git

	git config --global user.email "foo@bar.com"
	git config --global user.name "Foo"

### Obtener el repositiorio de Cyanogen para Gingerbread

	mkdir ~/android/system
	cd ~/android/system
	~/android/tools/repo init -u git://github.com/CyanogenMod/android.git -b gingerbread
	~/android/tools/repo sync -j16

### Obtener los archivos propietarios del Nexus.

Debemos tener un Nexus con CyanogenMod instalado

	cd ~/android/system/device/htc/passion/
	PATH=$PATH:~i/android/platform-tools/
	./extract-files.sh

### Obtener ROM manager

 Solo hace falta hacerlo si hay una nueva versión del programa

	~/android/system/vendor/cyanogen/get-rommanager

## Constriur Android

### Obtener actualizaciones

Este paso se puede obviar la primera vez que construimos puesto que acabaos de sincronizar el repo.

	~/android/system/vendor/cyanogen/get-rommanager
	cd ~/android/system/
	~/android/tools/repo sync

### Compilar

	cd ~/android/system/
	source build/envsetup.sh
	brunch passion

### Instalar

Para verlo en el emulador ejecutar

	emulator

Copiar `~/android/system/out/target/product/passion/update.cm-XXXXX-signed.zip` a la raiz de la tarjeta SD.

Opcional: Descagar __Google Apps for CyanogenMod 7__ y copiarlas la raiz de la tarjeta SD.

_Flashear_ ambos archivos `.zip` desde el _recovery_.