# Running your own Hardware Virtual Machine (HVM) on Amazon EC2.

For installing your favourite Linux flavour as an EC2 Amazon AMI (HVM) follow standard procedure of your distro of choice but make sure your kernel version is at least 3.14 and it has the following options enabled:

	Processor type and features  --->
	[*] Linux guest support (CONFIG_HYPERVISOR_GUEST)  --->
	[*]   Enable paravirtualization code (CONFIG_PARAVIRT)
	[*]     Paravirtualization layer for spinlocks (CONFIG_PARAVIRT_SPINLOCKS)
	[*]     Xen guest support (CONFIG_XEN)
	[*]   Support for running as a PVH guest (CONFIG_XEN_PVH)
	Device Drivers  --->
	[*] Block devices  --->
	<*>   Xen virtual block device support (CONFIG_XEN_BLKDEV_FRONTEND)
	[*] Network device support  --->
	<*>   Xen network device frontend driver (CONFIG_XEN_NETDEV_FRONTEND)

Sample `/etc/fstab` file

	/dev/xvda1 / ext4 noatime 0 1

Sample `/boot/grub/grub.conf` file

	default 0
	fallback 1
	timeout 0
	hiddenmenu

	title EC2 (partitioned)
	root (hd0,0)
	kernel /boot/kernel root=/dev/xvda1 rootfstype=ext4

	title EC2 (unpartitioned)
	root (hd0)
	kernel /boot/kernel root=/dev/xvda1 rootfstype=ext4
