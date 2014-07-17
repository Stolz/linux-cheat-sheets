Los nombres de dispositivos en ALSA tienen este formato:

	hw:x,y
	plughw:x,y
	hdmi:x,y

Siendo "x" el identificador de tarjeta (0,1,2,...) e "y" el identificador del stream.

Cuando usamos dispositivos "hw" estamos accediendo directamente al dispositivo hardware físico sin poder realizar nada que el hardware no soporte. Por ejemplo, si es una tarjeta de dos canales usando estos dispositivos no podemos sacar sonido 5.1.

Cuando usamos dispositivos "plughw" estamos accediendo a un dispositivo físico pero podemos usar plugins software para aumentar las posibilidades que ofrece el hardware. Por ejemplo podemos hacer up-mixing de 2 canales para que suene por 5 altavoces.

Cuando usamos dispositivos "hdmi" es lo mismo que "plughw" pero accediendo a un dispositivo lógico en vez de físico.

Podemos ver los identificadores de tarjeta con el comando:

	cat /proc/asound/cards

Podemos ver los identificadores de stream con el comando:

	aplay -l | grep card

Para probar el stream 3 de la tarjeta 0 por 6 altavoces:

	speaker-test -D hw:0,3 -c 6

Como los identificadores de tarjeta y de stream pueden cambiar dependiendo de los dispositivos conectados/habilitados es mejor acceder a ellos usando los alias que no cambian al reiniciar. Para ver los alias de todos los dispositivos ejecutar:

	aplay -L

Para probar usando los alias:

	speaker-test -c 6 -D hdmi:CARD=NVidia,DEV=1 #HDMI
	speaker-test -c 6 -D surround51:CARD=PCH,DEV=0 #Analogico

En el caso de surround51, como solo existe un alias podemos omitir todo lo que aparece tars los ":".


Mas info:
 <ftp://download.nvidia.com/XFree86/gpu-hdmi-audio-document/gpu-hdmi-audio.html#_alsa_user_space_physical_device_names>
