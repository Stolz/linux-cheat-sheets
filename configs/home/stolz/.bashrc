# /etc/skel/.bashrc

# This file is sourced by all *interactive* bash shells on startup, including some apparently interactive shells such as
# scp and rcp that can't tolerate any output. So make sure this doesn't display anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything past this point for scp and rcp, and it's important
# to refrain from outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Put your fun stuff here.

source /etc/profile

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

# To enable SSH-AGENT on KDE uncomment the proper lines at
# /etc/plasma/startup/agent-startup.sh /etc/plasma/shutdown/agent-shutdown.sh
