# Install RPM package in a a custom location

For instance, to install ImageMagick in the already existing `~/imagemagick` dir.

Search for package

	yum search ImageMagick | grep x86_64

Get download URL of package

	yumdownloader --urls ImageMagick

Download package and all its dependencies

	yumdownloader --resolve ImageMagick

Check if the RMP is relocatable

	rpm -qpi ImageMagick.x86_64.rpm | grep Relocations

If the RPM is relocatable, to install it in al alternative path

	rpm --prefix=~/imagemagick ImageMagick.x86_64.rpm

If it is not relocatable, to extract it

	cd ~/imagemagick
	rpm2cpio ImageMagick.x86_64.rpm | cpio -idmv

Probably required in `.bash_profile`

	export PATH="$PATH:$HOME/imagemagick/usr/bin"
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/imagemagick/usr/lib64"

Repeat the process with any other RPM that are dependencies of the installed package.
