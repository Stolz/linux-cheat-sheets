# eCryptfs
## Encript a directory

Required Kernel options

	File systems  --->
	[*] Miscellaneous filesystems  --->
	<M>   eCrypt filesystem layer support

Install required utils

	emerge ecryptfs-utils

From now on, all commands asume the `ecryptfs` kernel module is lodaded. If it's not, use the next command to load it

	modprobe ecryptfs

The goal is `/home/user/.private` directory to store our private stuff in a safe (encryped) way. Whenever we mount it we will have access to our private files and new files can be added. Whenever we unmount it the files will be encryped. While not mounted nothing can be written to this directory.

	cd # Now you should be in /home/user/
	mkdir -m 700 .private
	sudo mount -t ecryptfs .private .private

It will ask you the following questions:

 - **passphrase:** Enter your mount passphrase. You'll need it everytime you want to mount.
 - **cipher:** It's recommended to select "aes".
 - **key bytes:** The biggest you select, the stronger the encryption will be.
 - **plaintext passthrough:** Whether or not allow unencryped files in the directory. It's recommended to choose "no".
 - **filename encryption:** Whether or not encrypt the filenames. It's recommended to choose "yes".
 - **filename encryption Key (FNEK):** It's recommended to leave the default value.
 - **proceed with the mount:** Choose "yes".
 - **append sig:** Choose "yes".

The signature of the key(s) will be stored in `/root/.ecryptfs/sig-cache.txt`.

Lets create a test file:

	echo "This is top secret" > .private/test

Now, after umounting, the file name and file content should be encryped.

	sudo umount .private
	ls .private # We see only one file with file name begining with ECRYPTFS_FNEK_ENCRYPTED...
	cat .private/ECRYPTFS_FNEK_ENCRYPTED.*  # You should see garbage

Lets get it back by mounting again the directory. When asked, enter again the same data you enter before (passphrase, cipher, etc).

	sudo mount -t ecryptfs .private .private
	cat .private/test # You should see the unencryped content again

You don't have to always use the same passphrase/cipher options. If every time you mount the directory you use a different passphrase/cipher options the new content will be encryped with the new options, allowing you to have different files encryped with different options/passphrase in the same directory. This could be usefill for having a publicly shared directory where different data is encrypted by different users, and their keys.

