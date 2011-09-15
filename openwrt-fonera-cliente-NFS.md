# La Fonera como cliente NFS

Cómo configurar [La Fonera](http://wiki.fon.com/wiki/La_Fonera) con el firmware [OpenWrt](http://kamikaze.openwrt.org/) KAMIKAZE 7.09 para ser un cliente NFS.

## En la Fonera

	ipkg update
	ipkg install kmod-fs-nfs
	mount IP_DEL_SERVIDOR_NFS:/tmp /mnt -t nfs -o rw,nolock

## En el servidor NFS

Añadir al fichero `/etc/exports` la linea

	/tmp IP_DE_NUESTRA_FONERA(rw,no_root_squash,subtree_check) #Para la Fonera

Añadir al fichero `/etc/hosts.allow` las lineas

	portmap: IP_DE_NUESTRA_FONERA
	lockd: IP_DE_NUESTRA_FONERA
	rquotad: IP_DE_NUESTRA_FONERA
	mountd: IP_DE_NUESTRA_FONERA
	statd: IP_DE_NUESTRA_FONERA

y ejecutar

	/etc/init.d/portmap restart