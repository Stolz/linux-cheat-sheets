#!/system/bin/sh

# Script to repace Android Stack with a Linux chroot

# Config
export device=/dev/block/mmcblk1p1 #what to mount
export mount_point=/mnt/gentoo #where to mount it
export chroot_dir=$mount_point #chroot destination

#-------------------------------------------------------------------------------
# DO NOT MODIFY BELOW HERE !
#-------------------------------------------------------------------------------

error_exit() {
	echo ---------------
	echo "Error: $1"
	echo ---------------
	exit 1
}

# Mount Linux block device
mount -o rw,remount /system || error_exit "Unable to mount /system rw"
mkdir -p "$mount_point"
busybox grep -qs "$mount_point " /proc/mounts || busybox mount $device $mount_point || error_exit "Unable to mount $device on $mount_point"

# Look for chroot dir
[ -d "$chroot_dir" ] || error_exit "Unable to find chroot dir at $chroot_dir"

# Use our own busybox (Android Market ones are buggy!)
[ -f "$chroot_dir/bin/busybox" ] || error_exit "Unable to find custom busybox at $chroot_dir/busybox"
[ -x "$chroot_dir/bin/busybox" ] || error_exit "Custom $chroot_dir/busybox is not executable"

#Busybox shortcut
unalias b
alias b="$chroot_dir/bin/busybox"

# Copy mount info to chroot
b grep -v rootfs /proc/mounts > "$chroot_dir/etc/mtab"

# Mount all required partitions
b grep -qs "$chroot_dir/dev " /proc/mounts     || b mount -o bind /dev "$chroot_dir/dev"         || error_exit "Unable to bind $chroot_dir/dev"
b grep -qs "$chroot_dir/dev/pts " /proc/mounts || b mount -t devpts devpts "$chroot_dir/dev/pts" || error_exit "Unable to mount $chroot_dir/dev/pts"
b grep -qs "$chroot_dir/proc " /proc/mounts    || b mount -t proc proc "$chroot_dir/proc"        || error_exit "Unable to mount $chroot_dir/proc"
b grep -qs "$chroot_dir/sys " /proc/mounts     || b mount -t sysfs sysfs "$chroot_dir/sys"       || error_exit "Unable to mount $chroot_dir/sys"
b grep -qs "$chroot_dir/sdcard " /proc/mounts  || b mount -o bind /sdcard "$chroot_dir/sdcard"   || error_exit "Unable to bind $chroot_dir/sdcard"

# Sets up network forwarding
b sysctl -n -w net.ipv4.ip_forward=1 || error_exit "Unable to forward network"

# Chroot
# b chroot $chroot_dir /usr/bin/env -i HOME=/root USER=root PATH=/sbin:/bin:/usr/sbin:/usr/bin TERM=linux /bin/bash -l
# b chroot $chroot_dir /usr/bin/env -i HOME=/root USER=root PATH=/sbin:/bin:/usr/sbin:/usr/bin TERM=linux /usr/bin/screen -R -e "^Ee" /bin/bash -l
b chroot $chroot_dir /usr/bin/env -i HOME=/root USER=root PATH=/sbin:/bin:/usr/sbin:/usr/bin TERM=linux /usr/sbin/dropbear

#Network Feedback
netcfg | b grep UP | b egrep -v ^lo

#Switch off screen
input keyevent 26

# Stop Android Stack

#Next command will stop all the Android Stack
#stop
#But to avoid adbd restart we better stop the undesired services individually
stop root_service
stop bootanim
stop keystore
stop installd
stop drm
stop media
stop debuggerd
stop netd
stop vold
stop gps-daemon
stop dbus
stop servicemanager
stop zygote
stop surfaceflinger
#NOTE: Make sure than in your init.rc any of the above services have 'critical' or 'onrestart restart <service>'



