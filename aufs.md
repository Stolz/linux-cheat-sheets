# Aufs (advanced multi layered unification filesystem)

Unite several directories into a single virtual filesystem.

## Installation

**Note:** Aufs3 (Aufs version 3.x) only supports linux-3.0 and later.

	USE="kernel-patch" emerge sys-fs/aufs3

You need to rebuild your kernel after instalation

	genkernel all
	modprove -v aufs

## Example usage

Create sample dirs

	mkdir -p dir_one dir_two both_dirs
	touch dir_one/file1 dir_two/file2

Mount

	mount -t aufs -o dirs=dir_one:dir_two=ro none both_dirs

or

	mount -t aufs -o br:dir_one:dir_two=ro none both_dirs

Now `both_dirs` = `dir_two` + `dir_one`

	ls -1 both_dirs/
	file1
	file2


If you touch a file in `both_dirs`, this file will be show up in `dir_one`, not in `dir_two`, because `dir_two` is read only