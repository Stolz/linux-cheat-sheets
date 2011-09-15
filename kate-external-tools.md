# KDE Kate _External tools_ plugin

Reference <http://docs.kde.org/stable/en/kdebase-runtime/kate/kate-application-plugin-exttools.html>

## Enable
- Menu "Settings"
	- Configure Kate
		- Application
			- Pluggins-> Activate "External Tools"

## Add new
- Menu "Settings"
	- Configure Kate
		- External Tools -> New

## Add shortcut
- Menu "Settings"
	- Configure Shortcuts

## Add button to the tool bar
to-do <http://forum.kde.org/viewtopic.php?f=22&t=88531>

## Variables

<dl>
	<dt>%URL</dt>
		<dd> The full URL of the current document, or an empty string if the document is unsaved.

	<dt>%URLs</dt>
		<dd> A space separated list of the URLs of all open documents (except unsaved ones).

	<dt>%directory</dt>
		<dd> The directory part of the current documents URL or an empty string if the current document is unsaved.

	<dt>%filename</dt>
		<dd> The filename of the current document without the path, or an empty string if the current document is unsaved.

	<dt>%line</dt>
		<dd> The line number of the insertion cursor is in the current document.

	<dt>%column</dt>
		<dd> The column number of the insertion cursor in the current document.

	<dt>%selection</dt>
		<dd> The selected text in the current document, or an empty string if no text is selected

	<dt>%text</dt>
		<dd> The full text of the current document. Beware that this may potentially exceed the maximum command length allowed on your system. Use with care.
</dl>

# Examples

## Markdown

### Get code highlight

	git clone git://github.com/claes/kate-markdown.git
	mkdir -p ~/.kde4/share/apps/katepart/syntax/
	cp kate-markdown/markdown.xml -p ~/.kde4/share/apps/katepart/syntax/
	(system-wide, requires root) cp kate-markdown/markdown.xml /usr/share/apps/katepart/syntax/

### Install the tools

	mkdir -p ~/tmp && cd ~/tmp
	wget http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip -O Markdown.zip
	unzip Markdown.zip
	cp Markdown*/Markdown.pl /usr/local/bin/ #(May require root privileges)
	cd ..
	rm -r ~/tmp

	wget https://raw.github.com/Stolz/linux-cheat-sheets/master/markdown_preview.sh -O usr/local/bin/markdown_preview #(May require root privileges)

### Configure Kate

- Settings
	- Configure Kate > Application -> External Tools -> New
		- Label: Markdown preview
		- Script: markdown_preview %directory/%filename
		- Executable: markdown\_preview
		- Save: Current document
	- Configure Shortcuts
		- Assign Control+M to "Markdown preview"

## Kompare
- Settings
	- Configure Kate > Application -> External Tools -> New
		- Label: Kompare files
		- Script: kompare %URLs
		- Executable: kompare
