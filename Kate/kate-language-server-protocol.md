# Kate LSP plugin

Recent versions of Kate support [Language server protocol](https://microsoft.github.io/language-server-protocol/) (LSP) via a built in plugin.

The plugin supports [several server implementations](https://invent.kde.org/kde/kate/blob/master/addons/lspclient/settings.json) but it is possible toi provide a custom `settings.json` file to add more implementations.

To enable the plugin go to `Settings Menu -> Configure Kate -> Plugins` and select `LSP client`.

To provide a custom settings file go to `Settings Menu -> Configure Kate -> LSP CVlient` and select your file in the `Server configuration` field.


## PHP Language Server

To install the [LSP server for PHP](https://github.com/felixfbecker/php-language-server#installation)

	git clone git@github.com:felixfbecker/php-language-server.git
	cd php-language-server.git
	composer install --no-dev

Then create the file `kate-lsp.json`


	{
		"servers": {
			"php": {
				"command": ["php", "/home/javi/git/php-language-server/bin/php-language-server.php"],
				"url": "https://github.com/felixfbecker/php-language-server"
			}
		}
	}


And the configure Kate LSP plugin to use `kate-lsp.json`.
