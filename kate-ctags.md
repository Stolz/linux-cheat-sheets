Instalación

	dev-util/ctags

Para activar el plugin en Kate

	Preferencias->Configurar Kate->Complementos-> Marcar Ctags
	Preferencias->Configurar Kate-->Ctags

Para generar el fichero `tags`

	ctags -R

Para excluir ciertos archivos o directorios

	--exclude=".*"

Para buscar solo en ciertos tipos de lenguajes

	--languages=PHP

Para buscar solo en ciertos tipos de extensiones

	-h ".php"

Ver los tipos de expresiones reconocidos para PHP

	ctags --list-kinds=php
	c  classes
	i  interfaces
	d  constant definitions
	f  functions
	v  variables
	v  variables
	j  javascript functions
	j  javascript functions
	j  javascript functions

Para indicar que tipos de expresiones incluir (+) o excluir (-)

	--PHP-kinds=+cif-dvj

Para que las rutas sean relativas al fichero donde seencuentra el fichero tags y no al directorio desde donde se generar

	--tag-relative=yes

Para obtener estadisticas sobre los tags generados

	--totals=yes

En versiones antiguas de ctags si las declaraciones de funciones usan ámbito no las reconoce. Con esta regex se soluciona

	--regex-PHP='/(public\s+|static\s+|abstract\s+|protected\s+|private\s+)function\s+\&?\s*([^ (]+)/\2/f/'

Para no tener que repetir los parámetros constantemente podemos guardarlos en `~/.ctags`

	cat ~/.ctags
	-R
	--exclude=".*"
	--languages=PHP
	--PHP-kinds=+cif-dvj
	--tag-relative=yes
	--totals=yes
