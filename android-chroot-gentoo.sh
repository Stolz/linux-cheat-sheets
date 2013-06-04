# Config
export sd=/mnt/sdcard
export sd_dev=/dev/block/mmcblk0p5
export chroot_dir=$sd/gentoo

error_exit() {
	echo "Error: $1"
	exit 1
}

# Mount SD card
busybox grep -qs "$sd " /proc/mounts || busybox mount $sd_dev $sd || error_exit "Unable to mount $sd_dev on $sd"

# Use our own busybox (Market provided ones are buggy!)
[ -f "$sd/busybox" ] || error_exit "Unable to find custom busybox at $sd/busybox"
[ -x "$sd/busybox" ] || error_exit "Custom $sd/busybox is not executable"
unalias b
alias b="$sd/busybox"

# Look for chroot dir
[ -d "$chroot_dir" ] || error_exit "Unable to find chroot dir at $chroot_dir"
mkdir -p "$chroot_dir/sdcard"

# Mount all required partitions
mount -o rw,remount /system                  || error_exit "Unable to mount /system rw"
b grep -qs "$chroot_dir/dev " /proc/mounts     || b mount -o bind /dev "$chroot_dir/dev"         || error_exit "Unable to bind $chroot_dir/dev"
#b grep -qs "$chroot_dir/dev/pts " /proc/mounts || b mount -t devpts "devpts $chroot_dir/dev/pts" || error_exit "Unable to mount $chroot_dir/dev/pts"
b grep -qs "$chroot_dir/proc " /proc/mounts    || b mount -t proc proc "$chroot_dir/proc"        || error_exit "Unable to mount $chroot_dir/proc"
b grep -qs "$chroot_dir/sys " /proc/mounts     || b mount -t sysfs sysfs "$chroot_dir/sys"       || error_exit "Unable to mount $chroot_dir/sys"
b grep -qs "$chroot_dir/sdcard " /proc/mounts  || b mount -o bind /sdcard "$chroot_dir/sdcard"   || error_exit "Unable to bind $chroot_dir/sdcard"

# Sets up network forwarding
b sysctl -w net.ipv4.ip_forward=1 || error_exit "Unable to forward network"

# Chroot
b chroot $chroot_dir /bin/bash -l -c "/usr/sbin/env-update; source /etc/profile;bash"

# Shut down
echo "Shutting down chroot"
for pid in `b lsof | b grep -s $chroot_dir | b sed -e's/  / /g' | b cut -d' ' -f2`; do b kill -9 $pid >/dev/null 2>&1; done
sleep 5

b umount $chroot_dir/sdcard || echo "Error: Unable to umount $chroot_dir/sdcard"
b umount $chroot_dir/sys || echo "Error: Unable to umount $chroot_dir/sys"
b umount $chroot_dir/proc || echo "Error: Unable to umount $chroot_dir/proc"
#b umount $chroot_dir/dev/pts || echo "Error: Unable to umount $chroot_dir/dev/pts"
b umount $chroot_dir/dev || echo "Error: Unable to umount $chroot_dir/dev"



