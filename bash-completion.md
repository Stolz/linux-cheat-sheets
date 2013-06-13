# Bash-completion

	emerge app-shells/bash-completion

Esto crea el fichero /etc/profile.d/bash-completion.sh que es cargado desde /etc/profile cada bash --login.

## Configuración global (para todos los usuarios)

Estos pasos deben ser ejecutados con el usuario root.

Es necesario activar el módulo `base`

	eselect bashcomp disable --global `eselect bashcomp list | grep -v Available | cut -d "]" -f 2 | xargs`
	eselect bashcomp enable --global base

Además, en mi caso, suelo activar para todos los usuarios

	eselect bashcomp enable --global bash-builtins bind-utils bzip2 coreutils cpio dd eix eselect findutils gcc gentoo gzip make man mount mplayer openssl procps rsync screen sh ssh tar unrar util-linux

# Solo root

	eselect bashcomp enable e2fsprogs genkernel grub iptables layman mdadm module-init-tools net-tools shadow smartctl

# Solo mi usuario

	eselect bashcomp enable dbus git imagemagick qdbus subversion xhost xrandr
