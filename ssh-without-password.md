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

If you chose to use a password when you generated your keys it can get bothersome if you connect often to the same servers. You can use ssh-agent program to remember your password for the current session.

To integrate ssh-agent with KDE edit `/etc/xdg/plasma-workspace/env/10-agent-startup.sh` and `/etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh` and uncomment the lines referring to ssh-agent.

Now you can run the command `ssh-add` and KDE will remember your password for the current session.
