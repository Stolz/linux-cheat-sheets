# SSH without passowrd

Ref <http://www.gentoo.org/doc/en/keychain-guide.xml> <https://help.github.com/articles/working-with-ssh-key-passphrases/>

## Generate keys

Generate your personal SSH keys

	ssh-keygen -t dsa
	ssh-keygen -t rsa

Check permissions

    ls -l ~/.ssh/id_*
	-rw------- id_dsa
	-rw-r--r-- id_dsa.pub
	-rw------- id_rsa
	-rw-r--r-- id_rsa.pub

## Copy keys

In order to be able to connect to `user@server` without password you need to copy your keys to the server

	ssh-copy-id -i ~/.ssh/id_rsa.pub user@server

If you need to specify the SSH port

	ssh-copy-id -i ~/.ssh/id_rsa.pub user@server -p 2222

## SSH-Agent

If you chose to use a password when you generated your keys it can get bothersome if you connect often to the same servers. You can use ssh-agent program to remember your password for the current session

Edit `~/.bashrc`

	SSH_ENV="$HOME/.ssh/environment"

	# start the ssh-agent
	function start_agent {
		echo "Initializing new SSH agent..."
		# spawn ssh-agent
		ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
		echo succeeded
		chmod 600 "$SSH_ENV"
		. "$SSH_ENV" > /dev/null
		ssh-add
	}

	# test for identities
	function test_identities {
		# test whether standard identities have been added to the agent already
		ssh-add -l | grep "The agent has no identities" > /dev/null
		if [ $? -eq 0 ]; then
			ssh-add
			# $SSH_AUTH_SOCK broken so we start a new proper agent
			if [ $? -eq 2 ];then
				start_agent
			fi
		fi
	}

	# check for running ssh-agent with proper $SSH_AGENT_PID
	if [ -n "$SSH_AGENT_PID" ]; then
		ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
		if [ $? -eq 0 ]; then
		test_identities
		fi
	# if $SSH_AGENT_PID is not properly set, we might be able to load one from
	# $SSH_ENV
	else
		if [ -f "$SSH_ENV" ]; then
		. "$SSH_ENV" > /dev/null
		fi
		ps -ef | grep "$SSH_AGENT_PID" | grep -v grep | grep ssh-agent > /dev/null
		if [ $? -eq 0 ]; then
			test_identities
		else
			start_agent
		fi
	fi

To integrate ssh-agent with KDE edit `/etc/kde/startup/agent-startup.sh` and `/etc/kde/shutdown/agent-shutdown.sh` and remove the comments from lines referring to ssh-agent

	# /etc/kde/startup/agent-startup.sh
	if [ -x /usr/bin/ssh-agent ]; then
	  eval "$(/usr/bin/ssh-agent -s)"
	fi

	#/etc/kde/shutdown/agent-shutdown.sh
	if [ -n "${SSH_AGENT_PID}" ]; then
	  eval "$(ssh-agent -k)"
	fi

Now you can run the command `ssh-add` and KDE will remember your password for the current session.
