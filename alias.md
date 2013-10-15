# Alias

## Common

/etc/bash/bashrc

	alias df='pydf'
	alias l='locate -i'
	alias ls='ls -lh --color'
	alias la='ls -a'
	alias netstat='netstat -plutanW'
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
	alias kate=runkate

	#Common mistakes
	alias car='cat'
	alias vf='cd'
	alias jeo='joe'
	alias cd..='cd ..'

	PROMPT_COMMAND='if [[ $? -ne 0 ]]; then echo  -ne "\033[1;31m:(\033[0m\n";fi'

	#reuse kate and redirect output and errors to /dev/null
	runkate() {
		/usr/bin/kate -u "$@" > /dev/null 2>&1 &
	}

	#Colored man pages
	man() {
		# begin blinking
		# begin bold
		# end mode
		# end standout-mode
		# begin standout-mode - info box
		# end underline
		# begin underline

		env LESS_TERMCAP_mb=$(printf "\e[1m") \
		LESS_TERMCAP_md=$(printf "\e[1;32m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;37m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;33m") \
		man "$@"
	}

	function find_artisan_upstream
	{
		ORIGINAL_PWD="$PWD"
		while [[ "$PWD" != '/' ]]; do
			if [[ -f artisan ]]; then
				break
			else
				cd ..
			fi
		done

		if [[ -f artisan ]]; then
			php artisan "$@" --ansi
			cd "$ORIGINAL_PWD"
			return 0
		else
			echo artisan not found upstream
			cd "$ORIGINAL_PWD"
			return 1
		fi
	}

	function man_old () {
	if which konqueror >& /dev/null && [ $TERM != linux ] && \
		[ $TERM != screen.linux ] && [ -z $SSH_TTY ]; then
		konqueror man:/$1 --profile webbrowsing &
	else
		/usr/bin/man $1
	fi
	}

	function info_old () {
	if which konqueror >& /dev/null && [ $TERM != linux ] && \
		[ $TERM != screen.linux ] && [ -z $SSH_TTY ]; then
		konqueror info:/$1 --profile webbrowsing &
	else
		/usr/bin/info $1
	fi
	}

## User

$HOME/.bashrc

	alias su='sudo su'
	alias tv="disper -e"
	alias artisan="find_artisan_upstream"
	alias art="artisan"

	#Git
	alias ga='git add'
	alias gb='git branch'
	alias gba='git branch -a'
	alias gc='git commit -v'
	alias gcm='git commit -vm'
	alias gd='git diff'
	alias gds='git diff --staged'
	alias gdt='git difftool -y'
	alias gdtd='git difftool --dir-diff'
	alias gdts='git difftool -y --staged'
	alias gdtsd='git difftool --dir-diff --staged'
	alias gl='git log --decorate=short --graph --stat --oneline' #--no-merges
	alias gll='git log --decorate=short --graph --stat' # --oneline --no-merges
	alias gs='git status -bs'
	alias gr='git remote'
	alias grv='git remote -v'
	alias gmt='git mergetool'
	alias gmty='git mergetool -y'
	alias gr='git remote'
	alias grv='git remote -v'
	alias gmt='git mergetool'
	alias gmty='git mergetool -y'

	#SVN
	alias sd='svn diff | kompare -o -'
	alias st='svn status'

## Root

/root/.bashrc

	alias modprobe='modprobe -v'
	alias rmmod='rmmod -v'
	alias rescan-scsi-bus='rescan-scsi-bus --color'
	alias rescan='rescan-scsi-bus'
