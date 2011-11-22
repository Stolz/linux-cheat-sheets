# Comunem

	alias df='pydf'
	alias grep='grep --colour=auto --exclude-dir=.svn --exclude=*.svn-base --exclude-dir=.git'
	alias g='grep'
	alias l='locate -i'
	alias joe='joe --wordwrap'
	alias jeo=j
	alias ls='ls -lh --color'
	alias la='ls -a'
	alias top='htop'
	alias descomprimir='aunpack'

	function man () {
	if which konqueror >& /dev/null && [ $TERM != linux ] && \
		[ $TERM != screen.linux ] && [ -z $SSH_TTY ]; then
		konqueror man:/$1 --profile webbrowsing &
	else
		/usr/bin/man $1
	fi
	}

	function info () {
	if which konqueror >& /dev/null && [ $TERM != linux ] && \
		[ $TERM != screen.linux ] && [ -z $SSH_TTY ]; then
		konqueror info:/$1 --profile webbrowsing &
	else
		/usr/bin/info $1
	fi
	}


# User

	alias sd='svn diff | kompare -o -'
	alias st='svn status'
	alias gt='git status -s'
	alias su='sudo su'
	alias kate='/usr/bin/kate -u'

# Root

	alias modprobe='modprobe -v'
	alias rmmod='rmmod -v'
	alias rescan='rescan-scsi-bus --color'
