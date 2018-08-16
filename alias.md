# Bash Alias

File `/etc/bash/bashrc.d/alias`

	# Wander
	alias cd..='cd ..'
	alias ..='cd ..'
	alias ...='cd ../..'
	alias ....='cd ../../..'
	alias .....='cd ../../../..'

	# Common
	alias df='pydf'
	alias docker-compose='run_upstream docker-compose.yml docker-compose'
	alias grep='grep --colour=auto --exclude-dir=.git'
	alias g='grep'
	alias joe='joe --wordwrap'
	alias j='joe'
	alias l='locate -i'
	alias ls='ls -lh --color'
	alias la='ls -a'
	alias myip='wget -qO- http://ipecho.net/plain; echo'
	alias netstat='netstat -plutanW'
	alias ps='ps aux'
	alias r='reset'
	alias rsync='rsync --recursive --archive --delete --progress --stats --human-readable'
	alias tailf='tail -f'
	alias top='htop'
	alias wget='wget -c'
	alias youtube-dl='youtube-dl --no-check-certificate'
	alias yt='youtube-dl'

	# Git
	alias gitk='LC_ALL=C gitk'
	alias ga='git add'
	alias ga.='ga .'
	alias gb='git branch'
	alias gba='git branch -a'
	alias gc='git commit -v'
	alias gc.='gc .'
	alias gcm='git commit -vm'
	#alias gcmm='git commit -m "`wget http://whatthecommit.com/index.txt -qO-`"
	alias gcmm='git commit -m QuickCommit'
	alias gd='git diff -M'
	alias gd.='gd .'
	alias gds='gd --staged'
	alias gdt='git difftool -M -y'
	alias gdtd='git difftool --dir-diff'
	alias gdts='gdt --staged'
	alias gdtsd='gdtd --staged'
	alias gl='git log --decorate=short --graph --stat --oneline' #--no-merges
	alias gll='git log --decorate=short --graph --stat' # --oneline --no-merges
	alias gs='git status -bs'
	alias gs.='gs .'
	alias gr='git remote'
	alias grv='git remote -v'
	alias gmt='git mergetool'
	alias gmty='git mergetool -y'

	# Webdev
	alias lint='git status --porcelain | cut -c4- | xargs -n1 php -l'
	alias t='run_upstream phpunit.xml artisan config:clear; run_upstream phpunit.xml ./vendor/bin/phpunit -d max_execution_time=0'
	alias dof='run_upstream artisan ./bin/delete_old_files'
	alias watch='run_upstream webpack.mix.js npm run watch'
	alias assets='run_upstream webpack.mix.js npm run production'

	# Artisan
	alias artisan="run_upstream artisan php artisan --ansi"
	alias a="artisan"
	alias am="artisan migrate"
	alias ams="artisan migrate --seed"
	alias amf="artisan migrate:fresh --seed"
	alias amr="artisan migrate:refresh"
	alias amrs="artisan migrate:refresh --seed"
	alias arl="(tput rmam; artisan route:list; tput smam)"

	# Composer
	alias composer="php /usr/local/bin/composer --ansi"
	alias comp="run_upstream composer.json composer"
	alias dump="comp dump-autoload --optimize"
	alias icomposer='comp --ignore-platform-reqs'
	alias icomp='icomposer'

	# Common spelling mistakes
	alias car='cat'
	alias vf='cd'
	alias jeo='joe'
	alias late='kate'

File `/etc/bash/bashrc.d/functions`

	# Colored man pages
	man() {
		env LESS_TERMCAP_mb=$(printf "\e[1m") \
		LESS_TERMCAP_md=$(printf "\e[1;32m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;37m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;33m") \
		man "$@"
	}

	# Read MAN pages in browser
	xman()
	{
		if [ -z "$DISPLAY" ]; then
			man "$@"
		else
			BROWSER=firefox-bin man -H $1
		fi
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

File `/etc/bash/bashrc.d/variables`

	# Last command visual feedback
	PROMPT_COMMAND='if [[ $? -ne 0 ]]; then echo -ne "\033[1;31m:(\033[0m\n";fi'

	# Number of lines or commands that are stored in MEMORY in a history list while your bash session is ongoing.
	HISTSIZE=10000 #defaul: 500

	# Number of lines or commands that
	# - are allowed in the history FILE at startup time of a session,
	# - are stored in the history FILE at the end of your bash session for use in future sessions.
	HISTFILESIZE=10000 #defaul: 500

	# Do not save repeated lines or lines starting with a espace
	HISTCONTROL=ignoreboth:erasedups

File `$HOME/.bashrc`

	alias su='sudo su'

	LOG_AWK_COLORS='{matched=0}
	/DEBUG:/           {matched=1; print "\033[0;32m" $0 "\033[0m"} # GREEN
	/INFO:/            {matched=1; print "\033[1;32m" $0 "\033[0m"} # GREEN BOLD
	/NOTICE:/          {matched=1; print "\033[1;33m" $0 "\033[0m"} # YELLOW
	/WARNING:/         {matched=1; print "\033[0;33m" $0 "\033[0m"} # ORANGE
	/ERROR:/           {matched=1; print "\033[0;31m" $0 "\033[0m"} # RED
	/CRITICAL:/        {matched=1; print "\033[0;31m" $0 "\033[0m"} # RED
	/ALERT:/           {matched=1; print "\033[1;31m" $0 "\033[0m"} # RED BOLD
	/EMERGENCY:/       {matched=1; print "\033[1;31m" $0 "\033[0m"} # RED BOLD
	/Request headers:/ {matched=1; print "\033[0;36m" $0 "\033[0m"} # CYAN
	/Request body:/    {matched=1; print "\033[0;36m" $0 "\033[0m"} # CYAN
	/Response status:/ {matched=1; print "\033[1;36m" $0 "\033[0m"} # CYAN BOLD
	/Response body:/   {matched=1; print "\033[1;36m" $0 "\033[0m"} # CYAN BOLD
	matched==0                    {print "\033[1;30m" $0 "\033[0m"} # WHITE (DEFAULT if no match)'

	# Colorize Laravel logs
	ctailf () {
		if [ -z "$1" ] ; then
			echo "Please specify a log file for monitoring"
			return
		fi

		tail -n 10 -f $1 | awk "$LOG_AWK_COLORS"
	}

	# Colorize Laravel logs
	cless () {
		if [ -z "$1" ] ; then
			echo "Please specify a log file for pagination"
			return
		fi

		cat $1 | awk "$LOG_AWK_COLORS" | less -r
	}

File `/usr/share/bash-completion/completions/git`

	# Get completion also for aliases
	__git_complete g __git_main
	__git_complete ga _git_add
	__git_complete ga. _git_add
	__git_complete gb _git_branch
	__git_complete gba _git_branch
	__git_complete gc_git_commit
	__git_complete gc. _git_commit
	__git_complete gcm _git_commit
	__git_complete gcmm _git_commit
	__git_complete gd _git_diff
	__git_complete gd. _git_diff
	__git_complete gds _git_diff
	__git_complete gdt _git_difftool
	__git_complete gdtd _git_difftool
	__git_complete gdts _git_difftool
	__git_complete gdtsd _git_difftool
	__git_complete gl _git_log
	__git_complete gll _git_log
	__git_complete gr _git_remote
	__git_complete grv _git_remote
	__git_complete gmt _git_mergetool
	__git_complete gmty _git_mergetool

File `/root/.bashrc`

	alias genkernel='genkernel --makeopts=-j5'
	alias modprobe='modprobe -v'
	alias rescan-scsi-bus='rescan-scsi-bus --color'
	alias rescan='rescan-scsi-bus'
	alias rm='rm -i'
	alias rmmod='rmmod -v'
