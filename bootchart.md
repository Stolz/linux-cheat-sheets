NOTE: Obsolete. Check out [Bootchart2](https://wiki.gentoo.org/wiki/Bootchart2)


http://www.bootchart.org

	echo "app-benchmarks/bootchart acct java" >> /etc/portage/package.use
	emerge bootchart


Para que el grafico tenag más precisión reconfigurar el kernel con CONFIG_BSD_PROCESS_ACCT_V3

	[ ] General setup
		[ ] BSD Process Accounting
			[ ] BSD Process Accounting version 3 file format

En `/etc/bootchartd.conf` poner PROCESS_ACCOUNTING="yes"

Añadir a la linea kernel de la entrada Grub el parametro `init=/sbin/bootchartd`
