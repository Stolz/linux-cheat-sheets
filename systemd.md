
[Gentoo Wiki Systemd page](https://wiki.gentoo.org/wiki/Systemd)

### Servicios

Para ver un listado de todos los servicios instalados

	systemctl list-unit-files  --all
	systemctl --all --full
	ls /usr/lib/systemd/system

Para ver un listado de servicios que se inicial al arrancar

	systemctl list-units --all

Para activar/desactivar que se incie un servicio

	systemctl enable SOME.service
	systemctl disable SOME.service

Oara inciar/reiniciar/detener un servicio

	systemctl start SOME.service
	systemctl restart SOME.service
	systemctl stop SOME.service

Para ver el estado de un servicio

	systemctl status SOME.service

Para ver el log del sistema

	journalctl

Para ver los mensajes del log del sistema desde el último inicio

	journalctl -b

Equivalente a tail -f /var/log/messages

	journalctl -f

### Nombre de host

Establecer nombre

	hostnamectl set-hostname NOMBRE

Ver configuracion actual

	hostnamectl

### Fecha/Hora/Zona horaria

Ver zonas horarias

	timedatectl list-timezones

Establecer zona horaria

	timedatectl set-timezone Europe/Madrid

Establecer fecha y hora del reloj del sistema (system-time)

	timedatectl set-time "2013-01-01 01:00:00"

Establecer el estandar del reloj hardware (hardware-time o RTC)

	timedatectl set-local-rtc true  # hora local
	timedatectl set-local-rtc false # hora UTC

Sincronizar el reloj del sistema (system-time) desde el reloj hardware (hardware-time)

	timedatectl set-local-rtc true --adjust-system-clock

Sincronizar el reloj hardware (hardware-time) desde el reloj del sistema (system-time)

	timedatectl --adjust-system-clock

Activar/desactivar la sincronización NTP (debes tener NTP instalado)

	timedatectl set-ntp true  # activada
	timedatectl set-ntp false # desactivada

Comprobar la configuración actual

	timedatectl

¿Cuál elijo? La recomendación estandar es:

- Mantener el reloj del sistema en UTC para evitar problemas cuando cambie la hora en horario de verano.
- Al iniciar sincronizar el reloj del sistema desde el reloj hardware
- Mantener el reloj del sistema actualizado mediante NTP.
- Al apagar sincronizar el reloj hardware desde el reloj del sistema.

### Locales

Ver locales disponibles

	localectl list-locales

Establecer locale

	localectl set-locale LANG=es_ES.utf8

Comprobar la configuración actual

	localectl

### Teclado

Ver distribuciones de teclado disponibles

	localectl list-keymaps            # consola
	localectl list-x11-keymap-layouts # X

Establecer teclado

	localectl set-keymap es     # consola
	localectl set-x11-keymap es # X

Comprobar la configuración actual

	localectl
