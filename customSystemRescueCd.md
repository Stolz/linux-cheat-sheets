# Customize SystemRescueCd

<http://www.sysresccd.org/>

Mount offical CD image

	modprobe loop
	mkdir -p tmp_loop
	mount systemrescuecd-x86-3.5.1.iso tmp_loop -o loop

Copy CD contents to a temp dir and umount CD

	cp -a tmp_loop tmp_iso
	umount tmp_loop && rm tmp_loop -r

Make your desired changes in the tmp_iso dir. When you are done repack the new ISO image

	mkisofs -R -J -l -V StolzCD -input-charset utf-8 -o custom.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table tmp_iso


