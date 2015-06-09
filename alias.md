# Alias

## Common

/etc/bash/bashrc

	alias ..='cd ..'
	alias ...='cd ../..'
	alias ....='cd ../../..'
	alias cd..='cd ..'
	alias df='pydf'
	alias l='locate -i'
	alias ls='ls -lh --color'
	alias la='ls -a'
	alias netstat='netstat -plutanW'
	alias top='htop'
	alias rsync='rsync --recursive --archive --delete --progress --stats --human-readable'

	alias grep='grep --colour=auto --exclude-dir=.svn --exclude=*.svn-base --exclude-dir=.git'
	alias g='grep'

	alias descomprimir='aunpack'
	alias comprimir='apack'

	# Editor
	alias joe='joe --wordwrap'
	alias j='joe'
	alias kate=runkate
	#reuse kate and redirect output and errors to /dev/null
	runkate() {
		/usr/bin/kate -u "$@" > /dev/null 2>&1 &
	}

	# Common spelling mistakes
	alias car='cat'
	alias vf='cd'
	alias jeo='joe'

	# Last command visual feedback
	PROMPT_COMMAND='if [[ $? -ne 0 ]]; then echo -ne "\033[1;31m:(\033[0m\n";fi'

	# Colored man pages
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

	# Run "$2 $3 ... $n" in the first upstream directory that contains $1 file
	run_upstream()
	{
		PIVOT=$1
		ORIGINAL_PWD="$PWD"
		shift
		while [[ "$PWD" != '/' ]] && [[ ! -f "$PIVOT" ]]; do cd ..;done
		if [[ -f "$PIVOT" ]]; then
			"$@"
			cd "$ORIGINAL_PWD"
			return 0
		fi
		echo $PIVOT not found upstream
		cd "$ORIGINAL_PWD"
		return 1
	}

## User

$HOME/.bashrc

	alias su='sudo su'
	alias hdx='ssh root@hdx'

	# Git
	alias ga='git add'
	alias ga.='ga .'
	alias gb='git branch'
	alias gba='git branch -a'
	alias gc='git commit -v'
	alias gc.='gc .'
	alias gcm='git commit -vm'
	alias gcmm='git commit -m QuickCommit'
	alias gd='git diff'
	alias gd.='gd .'
	alias gds='git diff --staged'
	alias gdt='git difftool -y'
	alias gdtd='git difftool --dir-diff'
	alias gdts='git difftool -y --staged'
	alias gdtsd='git difftool --dir-diff --staged'
	alias gl='git log --decorate=short --graph --stat --oneline' #--no-merges
	alias gll='git log --decorate=short --graph --stat' # --oneline --no-merges
	alias gs='git status -bs'
	alias gs.='gs .'
	alias gr='git remote'
	alias grv='git remote -v'
	alias gmt='git mergetool'
	alias gmty='git mergetool -y'

	man()
	{
		if [ -z "$DISPLAY" ]; then
			man "$@"
		else
			kde-open man:$1
		fi
	}

	# PHP
	php()
	{
		hhvm "$@"
	}
	alias artisan="run_upstream artisan php artisan --ansi"
	alias art="artisan"
	alias composer="php /usr/local/bin/composer --ansi"
	alias comp="run_upstream composer.json composer"
	alias dump="comp dump-autoload --optimize"
	alias lint="git status -s | awk '/s/{print $2}' | xargs -n1 php -l"
	alias m="artisan migrate"
	alias ms="artisan migrate --seed"
	alias mr="artisan migrate:refresh"
	alias mrs="artisan migrate:refresh --seed"
	alias t="run_upstream phpunit.xml ./vendor/bin/phpunit"

## Root

/root/.bashrc

	alias modprobe='modprobe -v'
	alias rmmod='rmmod -v'
	alias rescan-scsi-bus='rescan-scsi-bus --color'
	alias rescan='rescan-scsi-bus'
