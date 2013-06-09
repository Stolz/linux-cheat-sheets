# Alias

## Common

	alias car='cat'
	alias df='pydf'
	alias l='locate -i'
	alias ls='ls -lh --color'
	alias la='ls -a'
	alias netstat='netstat -pultanW'
	alias s='ssh'
	alias top='htop'

	alias grep='grep --colour=auto --exclude-dir=.svn --exclude=*.svn-base --exclude-dir=.git'
	alias g='grep'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'

	alias descomprimir='aunpack'
	alias comprimir='apack'

	#Editor
	alias joe='joe --wordwrap'
	alias j='joe'
	alias jeo='joe'
	alias kate='/usr/bin/kate -u'

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

	PROMPT_COMMAND='if [[ $? -ne 0 ]]; then echo  -ne "\033[1;31m:(\033[0m\n";fi'

## User

	alias su='sudo su'
	alias tv="disper -e"

	#Git
	alias ga='git add'
	alias gb='git branch'
	alias gc='git commit -v'
	alias gd='git diff'
	alias gds='git diff --staged'
	alias gdt='git difftool -y'
	#alias gdt='git difftool --dir-diff'
	alias gdts='git difftool -y --staged'
	#alias gdts='git difftool --dir-diff --staged'
	alias gl='git log --decorate=short --oneline --graph --stat'
	alias gs='git status -bs'

	#SVN
	alias sd='svn diff | kompare -o -'
	alias st='svn status'

## Root

	alias modprobe='modprobe -v'
	alias rmmod='rmmod -v'
	alias rescan-scsi-bus='rescan-scsi-bus --color'
	alias rescan='rescan-scsi-bus'
