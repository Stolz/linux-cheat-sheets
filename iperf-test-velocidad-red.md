# iperf

Para hacer una prueba de velocidad de la red entre dos máquinas Linux, instalar en ambas `net-misc/iperf`

En el ordenador servidor ejecutar

	iperf -s

En el ordenador cliente

	iperf -c IP_DEL_SERVIDOR

Para que el servicio se quede funcionando de forma permanente

	rc-update add iperf
	/etc/init.d/iperf start
