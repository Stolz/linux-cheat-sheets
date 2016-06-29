# TP-Link TL-WN821N v 4.2 on Linux

The chipset of the dongle is

	# lsusb
	Bus 002 Device 008: ID 0bda:8178 Realtek Semiconductor Corp. RTL8192CU 802.11n WLAN Adapter

## Enable Kernel WiFi support

Required Kernel config

	[*] Networking support  --->
		[*]   Wireless  --->
			<M>   cfg80211 - wireless configuration API
			<M>   Generic IEEE 802.11 Networking Stack (mac80211)

	[*] Cryptographic API  --->
		<M>   AES cipher algorithms
		<M>   AES cipher algorithms (x86_64)
		<M>   AES cipher algorithms (AES-NI)

## In-kernel driver

This driver works but after a few minutes of no traffic the connection is lost. The logs show nothing, wpa_supplicant with -d option shows nothing, and ifconfig, wpa_gui ... all show that I am still connected, however if I try to load a webpage or even ping my router, nothing happends.

Required extra Kernel config

	-> Device Drivers
		[*] Network device support  --->
			[*]   Wireless LAN  --->
				<M>   Realtek rtlwifi family of devices  --->
					<M>   Realtek RTL8192CU/RTL8188CU USB Wireless Network Adapter (Module name: rtl8192cu)

In kernel 4.4.0 a new experimental driver with less features but more stable has been added but I still didn't tried it:

    -> Device Drivers
        [*] Network device support  --->
            [*]   Wireless LAN  --->
                <M>   RTL8723AU/RTL8188[CR]U/RTL819[12]CU (mac80211) support (RTL8XXXU Module name: rtl8xxxu)

It can coexist with the other drivers but you will need to control which module you wish to load.

## Propietary driver

Required extra Kernel config

	[*] Networking support  --->
		[*]   Wireless  --->
			[*]     cfg80211 wireless extensions compatibility (See footnote below!!)

The driver can be installed from an ebuild available in Maksbotan overlay

	# layman -a maksbotan
	# emerge -av sys-kernel/rtl8192cu-fixes

Make sure to remove the in-kernel driver brefore using this driver

	# rmmod rtl8192cu rtl_usb rtl8192c_common rtlwifi

To disable power saving (fixes bug in driver)

	cat /etc/modprobe.d/8192cu.conf
	# rtw_power_mgnt=0 disables power saving
	# rtw_enusbss=0 disables USB autosuspend
	options 8192cu rtw_power_mgnt=0 rtw_enusbss=0

To load the driver

	modprobe -v 8192cu

# Firmware

To get red of the following message in system log:

	rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
	rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
	rtlwifi: Firmware rtlwifi/rtl8192cufw_TMSC.bin not available

Install `linux-firmware` with `USE=savedconfig`

	echo 'sys-kernel/linux-firmware savedconfig' >> /etc/portage/package.use
	emerge sys-kernel/linux-firmware

Then edit file `/etc/portage/savedconfig/sys-kernel/linux-firmware-*` and leave only this line to avoid installing unnecessary firmwares

	rtlwifi/rtl8192cufw_TMSC.bin

Then reinstall the firmware

	emerge sys-kernel/linux-firmware

To make the configurartion valid for all versions of `linux-firmware`

	mv /etc/portage/savedconfig/sys-kernel/linux-firmware-* /etc/portage/savedconfig/sys-kernel/linux-firmware

## Connecting to networks

Make sure the card is recognized by the kernel

	# ifconfig -a
	wlp0s29u1u1: flags=4098<BROADCAST,MULTICAST>  mtu 1500
		ether a1:b2:c3:a4:b5:c6  txqueuelen 1000  (Ethernet)
		RX packets 0  bytes 0 (0.0 B)
		RX errors 0  dropped 0  overruns 0  frame 0
		TX packets 0  bytes 0 (0.0 B)
		TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

To connect to WPA networks we need to instal and configure WPA supplicant

	emerge wpa_supplicant

	cat /etc/conf.d/wpa_supplicant
	wpa_supplicant_args="-D nl80211 -i wlp0s29u1u1 -c /etc/wpa_supplicant/wpa_supplicant.conf"

	cat /etc/conf.d/net
	modules_wlp0s29u1u1="wpa_supplicant"
	config_wlp0s29u1u1="dhcp"

**Important:** Do not add wpa_supplicant to any runlevel. It will be controlled by `/etc/init.d/dhcpcd`.

Sample `/etc/wpa_supplicant/wpa_supplicant.conf` file

	update_config=0 # Set to "1" if you want to let any user of group "wheel" to alter this file using tools such wpa_cli or wpa_gui
	ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel

	network={
			ssid="MyWirelessNetwork"
			psk="SuperSecretPassword"
			key_mgmt=WPA-PSK
	}


**Note:** The propietary driver does not support the `nl80211` extension so the old `WEXT` must to be used instead. For using it, when invoking wpa_supplicant use `-D wext` instead of `-D nl80211`. It is also possible to try them both secuentialy and use the first one that is supoprted by the current driver by using `-D nl80211,wext`.

