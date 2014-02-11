# Quickly applying patches on Gentoo

Sometimes, it's necessary to apply a patch for a given package and there is no time and no desire to fork an ebuild to a custom overlay. Luckily Gentoo provides an easy way to so. All you need to do is to place a patch into the directory `/etc/portage/patches/[category]/[package]/new-fix.patch` or `/etc/portage/patches/[category]/[package]-[version]/new-fix.patch`.

Sadly, not all ebuilds in the portage tree has a build-in support for this feature and to be on the safe side you can put the following hook into the portage's bashrc file `/etc/portage/bashrc`:

	post_src_prepare() {
		if type epatch_user &> /dev/null ; then
			epatch_user
		fi
	}

Credits:

- https://wiki.gentoo.org/wiki//etc/portage/patches
- http://ewgeny.wordpress.com/2013/12/05/quickly-applying-patches-on-gentoo/
