# squash_dir
squash_dir is an init-script that when started uses the in-kernel squashfs (together with aufs or unionfs-fuse or others*) to mount 
a squashed directory rewritable and when stopped, recompresses the new directory.

*right now it can use:
sys-fs/aufs2
sys-fs/unionfs-fuse
sys-fs/funionfs
sys-fs/unionfs
sys-fs/aufs

## Kernel modules

	Device Drivers --->
	  Block Devices --->
	    <M> Loopback device support

	File systems --->
	  Miscellaneous Filesystems --->
	    <M> SquashFS
	     (include also LZO/XZ support if you plan to use any of them to compress the dir)


In order to get `loop` kernel module automatically loaded at boot edit `/etc/conf.d/module` and set

	modules="loop"

## Required programas

The easiest way of installing squash_dir is using the mv overlay via layman


	emerge -n layman
	layman -f
	layman -a mv
	emerge --sync


If you use eix, you can alternatively run `eix-sync`. In order to automatically updaye v overlay with eix-sync create the file `/etc/eix-sync.conf` with the next content:

	mv

## Installation

Now the mv overlay is ready. To install squash_dir

	emerge -av sys-fs/squash_dir


## Usage

To compress a dir you need to:

 - Create a symlink in /etc/init.d/squash_NAME pointing to /etc/init.d/squash_dir
 - Create a config file in /etc/conf.d/squash_NAME with at least 3 variables:
  - DIRECTORY: Directory to compress and also where the squashed filesystem should finally be mounted
  - DIR_SQUASH: Directory to store the unchanged and compressed data
  - DIR_CHANGE: Directory to store changes made to DIR_SQUASH
 - Add the service to the default runlevel and start it

	rc-update add squash_NAME default
	/etc/init.d/squash_NAME start

An optional variabel you can use in the config file is `COMPRESSION` for specify the compression method used by mksquashfs. If empty, the default mksquashfs algorithm (currently: "gzip") is used. Other possible values are "gzip", "xz", "lzo". If this variable is not specified, it defaults to that algorithm which is presumably best compressing (which is currently "xz"). "lzo" uses to be the fastest one. I you chose "xz" or "lzo" make sure you also enable corresponding kernel option for squashfs.

There are plenty more available configuration variables. Check the README file included in squash_dir package for more information.

# Examples

## Compress Portage tree

First you need to make sure both DISTDIR (by default /usr/portage/distfiles) and PKGDIR (by default /usr/portage/packages) are set to a place other than PORTDIR (by default /usr/portage/), because it makes no sense to keep them compressed by squash_dir. Both variables can be set in `/etc/make.conf`.

Create the symlink

	ln -s /etc/init.d/squash_dir /etc/init.d/squash_portage

Create the corresponding config file `/etc/conf.d/squash_portage` with the content:

	DIRECTORY="/usr/portage"
	DIR_SQUASH="/mnt/raid/0/squash/portage.readonly"
	DIR_CHANGE="/mnt/raid/0/squash/portage.changes"
	FILE_SQFS="/mnt/raid/0/squash/portage.sqfs"
	COMPRESSION="lzo"

Start the service

	rc-update add squash_portage default
	/etc/init.d/squash_portage start
