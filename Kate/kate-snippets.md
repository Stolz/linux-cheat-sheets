# Snippets de KATE

El plugin Snippets de KATE (http://www.kde.org/applications/utilities/kate/) permite añadir fragmentos de código fuente reutilizable para ahorrar algo de tiempo.

Cuando creamos un repositorio de snippets indicamos para qué tipo de ficheros se aplica (.c, .txt, .php, .sql,...). Para que se aplique a cualquier tipo de fichero basta con indicar un asterisco (*).

Se puede invocar al plugin de varias formas:

- Directamente seleccionando un snippets desde el panel.
- Con `Control+Espacio` vemos una lista de todos los snippets disponibles para el tipo de fichero actual.
- Al escribir, si tecleamos un fragmento de texto que coincide con el nombre de un snippet el plugin se invoca automáticamente ofreciendo todos los snippets del tipo de fichero actual cuyo nombre concuerda con el fragmento de texto escrito.
- Se puede asignar una copmbianción de teclas a cada snippet.

Para indicar una variable (parte del snippet editable por el usuario) usar la sintaxis `${variable}` ó `%{variable}`. Tras insertar un snippet el cursor se posiciona automáticamente en la primera variable. Presionando `TABULADOR` pasamos a la siguiente variable. Una vez que el usuario rellena una variable todas las demás ocurrencias de dicha variable son reemplazadas automáticamente. Al presiona `ESC` el cursor se posiciona en la posición en la que insertemos la variable especial `${cursor}`. Para acceder al texto seleccionado usar la variable especial `${selection}`.




Algunos ejemplos por Joseph Wenninger (http://www.jowenn.at) incluidos en el repositorio "testsnippets" que viene instalado por derfecto en Kate:

	This ${field} should be mirrored into ${field}
	Now with the first character being uppercase: ${field/./\u\0/}
	Now  should be underlined: ${field/(.)/=/g}
	All As are replaced by X: ${field/A/X/g}
	Now same but insensitive: ${field/A/X/gi}
	Now replace all \ by | : ${field/\\/|/g}
	Now replace all / by | : ${field/\//|/g}
	This adds an X to the end of the field : ${field/$/X/}
	This is broken, the regexp is not closed : ${field/a/b}
	This is broken, the regexp is not closed : ${field/a}
	This  replaces 1 by }\${blah} : ${field/1/}${blah}/}
	This snippet replaces 1 by }\${blah} : ${field/1/}${blah}/} ${blup}
	One mirrored field and one independent: ${field} ${blah}
	One mirrored field  with uppercasing and one independent: ${field/(.*)/\U\1\E/} ${blah}
	This snippet shows the operation of the @ operator, the second occurence of \${field} is the one the text is entered too, whereas the first occurence of \${field1} is the master ${field@} ${field1} ${field1}
	This snippet shows the operation of the @ operator, the second occurence of \${field} is the one the text is entered too, whereas the first occurence of \${field1} is the master ${field1} ${field1} ${field@}
	Test snippet for initial values \${no_init_value} ${no_init_value}
	\${with_init_value:Hello, I'm an init value} ${with_init_value:Hello, I'm an init value}
	\${with_brace:Hello, I contain a \}} ${with_brace:Hello, I contain a \}}
	\${with_brace_and_slashes:Hello, I contain a \ and one before the brace \\\}} ${with_brace_and_slashes:Hello, I contain a \ and one before the brace \\\}}
	\${i_m_mirrored} and initialized later \${i_m_mirrored@:Mirror mirror on the wall}
	${i_m_mirrored} and initialized later ${i_m_mirrored@:Mirror mirror on the wall}
	Not a regexp: \${not_a_regexp:hallo / blah} ${not_a_regexp:hallo / blah}
	This is a regexp: \${a_regexp} \${a_regexp/X/:/}
	This is a regexp: ${a_regexp} ${a_regexp/X/:/}

El plugin soporta QtScript

	The mirror value is calculated by a script: This ${field} should be mirrored into ${field`testit`}
	${fn} The filename of the document is ${fn`getFileName`}
	${fn`getFileName`} is the filename
	${fn`getFileName`} is the filename and now it is in uppercase: ${fn/(.*)/\U\1\E/} !!!

Ejemplo de funciones:

	function testit(src) {
			debug("HELLO I'm a script");
			return "HELLO I'm a script. Text is:"+src+" I'm done";
	}
	function getFileName(src) {
			return document.fileName();
	}