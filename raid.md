Crear un raid

	mdadm --create --verbose --metadata=0.90 /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1

Crear un raid (version compacta equivalente a la anterior)

	mdadm -Cv -e 0 /dev/md0 -l1 -n2 /dev/sd[ab]1

Ver el estado de los raids

	watch cat /proc/mdstat

Generar el archivo de configuración con los raids actualmente iniciados

	mdadm --detail --scan > /etc/mdadm.conf

Generar el archivo de configuración con todos los raids existentes (aunque no estén iniciados)

	mdadm --examine --scan > /etc/mdadm.conf

Detener un raid

	mdadm --manage --stop /dev/md0

Iniciar un raid

	mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1

Borrar un raid

	mdadm --remove /dev/md0

Iniciar un raid al que le falta un disco

	mdadm --assemble --run /dev/md0 /dev/sda1

Tras el fallo de un disco del raid, volver a añadir un disco

	mdadm --add /dev/md0 /dev/sdb1

Marcar un disco como fallado

	mdadm --fail /dev/md0 /dev/sda1

Eliminar un disco de un raid (debe estar marcado como fallado)

	mdadm --remove /dev/md0 /dev/sda1

Renombrar un raid (deben estar desmontado)

    mdadm --stop /dev/md127
    mdadm --assemble --update=super-minor /dev/md0 /dev/sda1 /dev/sdb1

Eliminar el suprbloque de un disco

	mdadm --zero-superblock /dev/sda

Copiar el particionado de un disco a otro

	sfdisk -d /dev/sda | sfdisk /dev/sdb

Ejemplo de /etc/mdadm.conf

	MAILADDR root@localhost
	ARRAY /dev/md0 metadata=0.90 level=raid1 num-devices=2 UUID=cd9afc1b:45e493cb:be643f6f:37b88004
	ARRAY /dev/md1 metadata=0.90 level=raid1 num-devices=2 UUID=9a8b2b97:e66c7189:7caafda7:20c28eaa
	ARRAY /dev/md2 metadata=0.90 level=raid0 num-devices=2 UUID=3c43cf12:dffa1a79:4ca75251:5a9de757
	ARRAY /dev/md3 metadata=0.90 level=raid0 num-devices=2 UUID=7ce32869:dc84af2d:5ebcfcaf:b88e8848
	ARRAY /dev/md4 metadata=0.90 level=raid0 num-devices=2 UUID=95d59b22:3764d021:5e87585e:ecdc9514
	ARRAY /dev/md5 metadata=0.90 level=raid0 num-devices=2 UUID=ec662f03:779bea5a:c8bad7d3:2e2a025a
	ARRAY /dev/md6 metadata=0.90 level=raid1 num-devices=2 UUID=ddad76e1:44e99927:ad72ecf4:1e4eea04
