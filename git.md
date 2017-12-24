# Git cheat sheet

## Instalación, configuración y ayuda

### Instalación en Gentoo

	emerge -av git

### Consultar ayuda de un comando

Los tres comandos son equivalentes

	git help <comando>
	git <comando> --help
	man git-<comando>

###  Configuración de usuario

Con el parámetro `--global` afectan a todos los repositorios, de lo contrario solo al repositorio en el que nos encontremos.

	git config --global user.name "Stolz"
	git config --global user.email stolz@example.com

###  Configuración para activar los colores

	git config --global color.ui auto

###  Para ver las opciones de configuración

	git config --global -l

###  Configuracion de github

	git config --global github.user Stolz
	git config --global github.token <token>

### Push solo de rama actual por defecto

Por defecto push envía todas las ramas. Para hacer que por defecto envíe solo la actual

	git config --global push.default current

### Ignorar archivos

Crear en la raíz de la copia de trabajo el fichero `.gitignore` con el listado de ficheros a ignorar.
Acepta comentarios con `#`, comodines con `*` y excepciones con `!`. Ej:

	#Ignore editor backup files
	*~
	.*~
	.old

	#Ignore chache (but exlude README.html)
	cache/*
	!cache/README.html

### Ignorar cambios en archivos para evitar publicar datos sensibles

En ocasiones es útil evitar que ciertos cambios en archivos sean confirmados, por ejemplo para evitar hacer un `commit` y posterior `push` de contraseñas de base de datos o claves API. Para ello se puede marcar los archivos cuyos cambios queremos que sean ignorados con el flag `--assume-unchanged`.

	git update-index --assume-unchanged <archivo>

Para restablecer el flag

	git update-index --no-assume-unchanged <archivo>

Los archivos con el flag activado no serán preparados con `git commit -a`. Sin embargo si añadimos específicamente el archivo con `git add <archivo>` sí sera preparado pero cualquier `merge` de dicho commit dará un fallo para que podamos encargarnos de él a mano.

Para facilitar el uso podemos definir los siguienes alias

	[alias]
			ignore = !git update-index --assume-unchanged
			unignore = !git update-index --no-assume-unchanged
			ignored = !git ls-files -v | grep ^[a-z]

De forma que es posible hacer

	git ignore <archivo>
	git unignore <archivo>
	git ignored #Ver listado de archivos ignorados

## Crear/importar repositorio

### Crear repositorio para un nuevo proyecto

	mkdir <proyecto>
	cd <proyecto>
	git init
	git add .
	git commit -m "Carga inicial"

### Clonar repositorio existente y añadir remoto para incorporar cambios del proyecto original

	git clone git@github.com:Stolz/CodeIgniter.git
	cd CodeIgniter
	git remote add upstream git://github.com/EllisLab/CodeIgniter.git

### Descargar los cambios del repositorio remoto pero no incorporarlos a la copia local

Esto no altera nuestros ficheros

	git fetch

### Incorporar los los cambios descargados a nuestra copia local

	git merge

En caso de que existan conflictos podemos usar una herramienta externa para resolverlos de forma más visual

	git mergetool -y

`git mergetool` soporta varias herramientas en intentará usar alguna de las que se encuentre instalada. Para indicar una herramiento en concreto:

	git mergetool -t <herramienta>

También podemos indicar qué herramienta usar por defecto para mergetool

	git config --global merge.tool <herramienta>

Las herramientas soportadas son: araxis, bc3, diffuse, ecmerge, emerge, gvimdiff, kdiff3, meld, opendiff, p4merge, tkdiff, tortoisemerge, vimdiff y xxdiff.

### Descargar e incorporar los cambios del repositorio remoto a la copia local

Equivale a `git fetch` + `git merge`

	git pull [ -n | --dry-run]

## Obtener información del repositorio

### Para ver el log del repositorio

	git log

Eyecandy

	git log --decorate=short --oneline --graph --stat

También existen visores gráficos incluídos

	gitview #Requiere USE="python"
	gitk #Requiere USE="tk"
	git gui

### Ver estado de nuestra copia de trabajo

	git status [-s para verlo resumido -b para ver la rama actual]

## Hacer cambios

Tu repositorio local esta compuesto por tres "árboles" administrados por git. El primero es tu ""Directorio de trabajo"" el cual contiene los archivos. el segundo es el `Index` el cual actua como un área intermedia y finalmente el `HEAD` el cual apunta a el último commit realizado.


### Añadir

Para añadir archivos al `Index` (también llamado proponer cambios)

	git add <archivos>

Para borrar renombrar archivo/s

	git rm <archivos>
	git mv <archivos>

### Ver los cambios que has hecho y que todavía no has preparado

(cambios no no preparados = no irán en el próximo commit)

	git diff

### Ver los cambios que has hecho y que están preparados

(irán en el próximo commit)(nota:--staged = --cached)

	git diff --staged

El parámetro `--cached` es un alias de `--staged`

### Ver los cambios que has hecho, estén o no preparados

Es decir, ver la diferencia entre tu copia de trabajo y el ultimo commit

	git diff HEAD

### Usar una herramienta externa para ver las diferencias

	git difftool

`git difftool` es un frontend para git diff y acepta los mismos parámetros. Soporta varias herramientas e intentará usar alguna de las que se encuentre instalada. Para indicar una herramiento en concreto:

	git difftool -t <herramienta>

También podemos indicar qué herramienta usar por defecto para mergetool

	git config --global diff.tool <herramienta>

Las herramientas soportadas son: araxis, bc3, diffuse, emerge, ecmerge, gvimdiff, kdiff3, kompare, meld, opendiff, p4merge, tkdiff, vimdiff and xxdiff.

### Para revertir los cambios

	git checkout <archivo>

### Preparar nuevos cambios en un archivo previamente preparado pero aun no confirmado

	git add <archivo>

### Cancelar el estado preparado de un archivo

	git reset HEAD <archivo>

### Confirmar los cambios preparados

`-a` indica todos los archivos

	git commit -a [-m comentario] [-v para añadir al editor de texo el parche y asi tener una idea de que poner en el comentario]

### Enviar los cambios al repositorio remoto

	git push [-n | --dry-run]

## Ramas

### Ver ramas

	git branch

### Ver ramas remotas

	git branch -r

### Ver ramas ya incorporadas a la rama actual

	git branch --merged

Las ramas mostradas es seguro borrarlas.

### Ver ramas no incorporadas a la rama actual

	git branch --no-merged

### Crear nueva rama

	git branch <nuevarama>

### Cambiar de rama

	git checkout <rama>

### Crear nueva rama y cambiar a ella

	git checkout -b <rama>

### Borrar rama

	git branch -d <rama>

### Incorporar rama2 a rama1

	git checkout <rama1>
	git merge --no-ff <rama2>

### Enviar solo la rama actual a repositorio remoto

	git push origin HEAD
