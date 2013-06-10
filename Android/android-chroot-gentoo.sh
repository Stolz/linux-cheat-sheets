# Script to launch a Linux chroot in Android
# If any parameter is given, Zygote and all Android services will be stopped

# Config
export device=/dev/block/mmcblk0p5 #what to mount
export mount_point=/mnt/sdcard #where to mount it
export chroot_dir=$mount_point/gentoo #chroot destination

# DO NOT MODIFY BELOW HERE !

error_exit() {
	echo ---------------
	echo "Error: $1"
	echo ---------------
	exit 1
}

mount -o rw,remount /system || error_exit "Unable to mount /system rw"

# Mount SD card
mount -o rw,remount /system
mkdir -p "$mount_point"
busybox grep -qs "$mount_point " /proc/mounts || busybox mount $device $mount_point || error_exit "Unable to mount $device on $mount_point"

# Look for chroot dir
[ -d "$chroot_dir" ] || error_exit "Unable to find chroot dir at $chroot_dir"
mkdir -p "$chroot_dir/sdcard"

# Use our own busybox (Android Market's are buggy!)
[ -f "$chroot_dir/static-bin/busybox" ] || error_exit "Unable to find custom busybox at $chroot_dir/busybox"
[ -x "$chroot_dir/static-bin/busybox" ] || error_exit "Custom $chroot_dir/busybox is not executable"
unalias b
alias b="$chroot_dir/static-bin/busybox"

# Copy mounts to chroot
b grep -v rootfs /proc/mounts > "$chroot_dir/etc/mtab"

# Mount all required partitions
b grep -qs "$chroot_dir/dev " /proc/mounts     || b mount -o bind /dev "$chroot_dir/dev"         || error_exit "Unable to bind $chroot_dir/dev"
b grep -qs "$chroot_dir/dev/pts " /proc/mounts || b mount -t devpts devpts "$chroot_dir/dev/pts" || error_exit "Unable to mount $chroot_dir/dev/pts"
b grep -qs "$chroot_dir/proc " /proc/mounts    || b mount -t proc proc "$chroot_dir/proc"        || error_exit "Unable to mount $chroot_dir/proc"
b grep -qs "$chroot_dir/sys " /proc/mounts     || b mount -t sysfs sysfs "$chroot_dir/sys"       || error_exit "Unable to mount $chroot_dir/sys"
# b grep -qs "$chroot_dir/sdcard " /proc/mounts  || b mount -o bind /sdcard "$chroot_dir/sdcard"   || error_exit "Unable to bind $chroot_dir/sdcard"

# Sets up network forwarding
b sysctl -w net.ipv4.ip_forward=1 || error_exit "Unable to forward network"

# Stop Zygote and all the Android services to have more RAM in our chroot
if [[ -n  $1 ]]; then stop; fi

# Chroot
#b chroot $chroot_dir /bin/bash -l -c "/usr/sbin/env-update; source /etc/profile;bash"
b chroot $chroot_dir /usr/bin/env -i HOME=/root USER=root PATH=/sbin:/bin:/usr/sbin:/usr/bin TERM=linux /bin/bash -l

# Shut down chroot
echo "Shutting down chroot"
for pid in `b lsof | b grep -s $chroot_dir | b sed -e's/  / /g' | b cut -d' ' -f2`; do b kill -9 $pid >/dev/null 2>&1; done
sleep 5

# Restart Zygote
if [[ -n  $1 ]]; then start; fi

# b umount $chroot_dir/sdcard || echo "Error: Unable to umount $chroot_dir/sdcard"
b umount $chroot_dir/sys || echo "Error: Unable to umount $chroot_dir/sys"
b umount $chroot_dir/proc || echo "Error: Unable to umount $chroot_dir/proc"
b umount $chroot_dir/dev/pts || echo "Error: Unable to umount $chroot_dir/dev/pts"
b umount $chroot_dir/dev || echo "Error: Unable to umount $chroot_dir/dev"
