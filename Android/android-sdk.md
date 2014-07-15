# Android

## Instalar JAVA

Para desarollar hace falta tener un JDK (el JRE no es suficiente). En la fecha actual se requiere JDK 6. Para instalarlo:

	emerge -n dev-java/sun-jdk

Para que el perfil lo use por defecto

	eselect java-vm list
	eselect java-vm set system sun-jdk-1.6

Ahora, para compilar los proyectos Android necesitamos el comando ant:

	echo "dev-java/ant -*" >> /etc/portage/package.use
	emerge -n ant

Dependencias instaladas por ant:

dev-java/javatoolkit
dev-java/ant-core
dev-java/xml-commons-external
dev-java/ant-nodeps
dev-java/junit
dev-java/bcel
dev-java/javacup
dev-java/xml-commons-external
dev-java/xjavac
dev-java/xml-commons-resolver
dev-java/ant-junit
dev-java/xalan-serializer
dev-java/xerces
dev-java/xalan
dev-java/ant-apache-xalan2
dev-java/ant-trax
dev-java/ant

## Instalar el SDK de Android

Para tener los comandos `adb` y `fastboot` instalar dev-util/android-tools. Para tener el comando `android` instalar dev-util/android-sdk-update-manager.

	emerge -nav dev-util/android-tools dev-util/android-sdk-update-manager

Añadir a nuestro usuario al grupo android

	gpasswd -a <user> android

Para lanzar el administrador del SDK que nos permite descargar todo lo necesario ejecutar:

	andorid

En Android 4.0.3 (API 15) marcar:

- SDK Platform
- ARM EABI System image

## Ver los SDK instalados

	android list targets

## Crear un dispositivo virtual (AVD ó emulador)

	android create avd --name mi_emulador --target 1

(responder no a la pregunta de usar un perfil de hadware personalizado)

## Ver los emuladores instalados

	android list avd

Para abrir un gestor visual de los AVDs

	android avd

## Lanzar el emulador

	emulator -avd mi_emulador

O de forma visual de nuevo

	android avd

Para rotar la pantalla Ctrl+F11/Ctrl+F12.


## Crear un proyecto:

	android create project \
	--target 1 \
	--name mi_proyecto \
	--path ~/android/mi_proyecto \
	--activity mi_proyecto \
	--package com.example.stolz

## Compilar un proyecto (crear el APK)

Para poder instalar el .apk en un teléfono o emulador, el apk tiene que estar firmado. Si compilamos el proyecto en modo depuración se firma automaticamente pero si lo compilamos en modo release luego hay que firmar el apk a mano. Para simplificar de momento solo explico cómo compilar en modo depuración:

	cd ~/android/mi_proyecto
	ant debug

(esto crea el archivo `mi_proyecto-debug.apk` en el direcotiro `bin` del proyecto)

Si queremos que además de compilarlo se instale en el emulador (el emulador debe estar ejecutandose)

	ant debug install

## Instalar un proyecto en el emulador

Primero lanzar el emulador

	android avd

Luego instalar el apk

	adb install ~/android/mi_proyecto/bin/mi_proyecto-debug.apk
