# squash_dir
squash_dir is an init-script that when started uses the in-kernel squashfs (together with aufs or unionfs-fuse or others*) to mount 
a squashed directory rewritable and when stopped, recompresses the new directory.

It comes very handy for people who is running low on disk space or using SSD disk drives. The access to the squashed dir is similar and usually is even faster than the normal method, pependig on the nature of the compressed data.

[*] right now it can use:

 - sys-fs/aufs2
 - sys-fs/unionfs-fuse
 - sys-fs/funionfs
 - sys-fs/unionfs
 - sys-fs/aufs


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


If you use eix, you can alternatively run `eix-sync`. In order to automatically update mv overlay with eix-sync create the file `/etc/eix-sync.conf` with the next content:

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

An optional variabel you can use in the config file is `COMPRESSION` for specify the compression method used by mksquashfs. If empty, the default mksquashfs algorithm (currently: "gzip") is used. Other possible values are "gzip", "xz", "lzo". If this variable is not specified, it defaults to that algorithm which is presumably best compressing (which is currently "xz"). "lzo" uses to be the fastest one. If you chose "xz" or "lzo" make sure you also enable corresponding kernel option for squashfs.

There are plenty more available configuration variables. Check the README file included in squash_dir package for more information.

# Examples

__NOTE:__ I use squash_dir to make room in my SSD drive and avoid extra writes. All my squashed files and dirs are stored in a rotational disks raid. I've plenty room in the raid so I've used lzo compression for all the examples because it uses to be the fastest one and I don't want to wait too much in every shutdown in case there are changes in my squashed dirs. If you are running low on disk space consider using other options such "xz". Whatever compression method you use, make sure `sys-fs/squashfs-tools` and kernel are compiled with corresponding options.


## Compress Portage tree

The Portage tree is the perfect candidate to be compressed with squash_dir because it has thousand of small text files that can be easily recovered in case something bad happens.

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

## Compress kernel sources

The kernel sources dir is also a good candidate to be compressed with squash_dir. It also has thousand of small files that can be easily recovered.

Create the symlink

	ln -s /etc/init.d/squash_dir /etc/init.d/squash_kernel

Create the corresponding config file `/etc/conf.d/squash_kernel` with the content:

	DIRECTORY="/usr/src"
	DIR_SQUASH="/mnt/raid/0/squash/kernel.readonly"
	DIR_CHANGE="/mnt/raid/0/squash/kernel.changes"
	FILE_SQFS="/mnt/raid/0/squash/kernel.sqfs"
	COMPRESSION="lzo"

Start the service

	rc-update add squash_kernel default
	/etc/init.d/squash_kernel start


## Compress /var/db

The directory `/var/db` could be a perfect candidate to be squashed but it's rather vital to your system. If it is lost you have practically completely messed up your system. It's up to you to take the risk of using squash_dir with it. If you decide to go on, at least a backup of the previous compressed data should always be kept using the `FILE_SQFS_OLD` config variable. I don't recomend to squash it but if you decide to do so, here is a possible configuration to use:


Create the symlink

	ln -s /etc/init.d/squash_dir /etc/init.d/squash_db

Create the corresponding config file `/etc/conf.d/squash_db` with the content (Note here I'm using my raid1, not my raid0'):

	DIRECTORY="/var/db"
	DIR_SQUASH="/mnt/raid/1/squash/db.readonly"
	DIR_CHANGE="/mnt/raid/1/squash/db.changes"
	FILE_SQFS="/mnt/raid/1/squash/db.sqfs"
	FILE_SQFS_OLD="/mnt/raid/1/squash/db.sqfs.bak"
	COMPRESSION="lzo"

Start the service

	rc-update add squash_db default
	/etc/init.d/squash_db started

## Compress docs

Create the symlink

	ln -s /etc/init.d/squash_dir /etc/init.d/squash_doc

Create the corresponding config file `/etc/conf.d/squash_doc` with the content:

	DIRECTORY="/usr/share/doc"
	DIR_SQUASH="/mnt/raid/0/squash/doc.readonly"
	DIR_CHANGE="/mnt/raid/0/squash/doc.changes"
	FILE_SQFS="/mnt/raid/0/squash/doc.sqfs"
	COMPRESSION="lzo"

Start the service

	rc-update add squash_doc default
	/etc/init.d/squash_doc start