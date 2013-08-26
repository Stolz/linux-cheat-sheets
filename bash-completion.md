# Bash-completion

	emerge app-shells/bash-completion

Esto crea el fichero /etc/profile.d/bash-completion.sh que es cargado desde /etc/profile cada bash --login.

## Configuración global (para todos los usuarios)

Estos pasos deben ser ejecutados con el usuario root.

Es necesario activar el módulo `base`

	eselect bashcomp disable --global `eselect bashcomp list | grep -v Available | cut -d "]" -f 2 | xargs`
	eselect bashcomp enable --global base

Además, en mi caso, suelo activar para todos los usuarios

	eselect bashcomp enable --global alias bash-builtins bind-utils bzip2 chown configure coreutils cpio dd eix eselect export file find findutils gcc gentoo gzip htop id iperf kill killall lsof ncftp make man mount mplayer mysql nslookup openssl pidof procps ping rsync screen sh sqlite3 ssh ssh-add ssh-copy-id su tailf tar tracepath umount unrar util-linux watch wget

# Solo root

	eselect bashcomp enable cfdisk e2fsprogs e2label fdisk fsck genkernel genlop groupadd groupdel groupmems groupmod grub hwclock iptables layman mdadm modinfo modprobe module-init-tools net-tools passwd rmmod sfdisk shadow smartctl swapon sysctl tune2fs useradd userdel usermod

# Solo mi usuario

	eselect bashcomp enable dbus git imagemagick qdbus subversion sudo xhost xrandr wine
