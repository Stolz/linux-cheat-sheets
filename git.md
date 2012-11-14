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
Acepta comentarios con `#`, comodines con `*` y excepciones con `!`.

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

El segundo comando es lo mismo pero de forma gráfica

    git log [--stat]
    gitview

### Ver estado de nuestra copia de trabajo

    git status [-s para verlo resumido]

## Hacer cambios

### Añadir, borrar renombrar archivo/s

    git add <archivos>
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

git difftool es un frontend para git diff y acepta los mismos parámetros. Soporta varias herramientas e intentará usar alguna de las que se encuentre instalada. Para indicar una herramiento en concreto:

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

# GitHub workflow

- Fork on GitHub (click Fork button)
- Clone to computer `$ git clone git@github.com:Stolz/CodeIgniter.git`
- Don't forget to cd into your repo: `$ cd CodeIgniter/ `
- Set up remote upstream `$ git remote add upstream git://github.com/EllisLab/CodeIgniter.git`
- Create a branch for new issue `$ git checkout -b new-feature`
- Develop on issue branch. [Time passes, the main repository accumulates new commits]
- Commit changes to issue branch. `$ git add . ; git commit -m 'commit message'`
- Fetch upstream `$ git fetch upstream`
- Update local master `$ git checkout master; git pull upstream master`
- Repeat steps 5-8 till dev is complete
- Rebase issue branch `$ git checkout new-feature; git rebase master`
- Push branch to GitHub `$ git push origin new-feature`
- Issue pull request (Click Pull Request button)


You might benefit from the workflow Scott Chacon describes in Pro Git. In this workflow, you have two branches that always exist, master and develop.

master represents the most stable version of your project and you only ever deploy to production from this branch.

develop contains changes that are in progress and may not necessarily be ready for production.

From the develop branch, you create topic branches to work on individual features and fixes. Once your feature/fix is ready to go, you merge it into develop, at which point you can test how it interacts with other topic branches that your coworkers have merged in. Once develop is in a stable state, merge it into master. It should always be safe to deploy to production from master.

Scott describes these long-running branches as "silos" of code, where code in a less stable branch will eventually "graduate" to one considered more stable after testing and general approval by your team.

Step by step, your workflow under this model might look like this:

    You need to fix a bug.
    Create a branch called myfix that is based on the develop branch.
    Work on the bug in this topic branch until it is fixed.
    Merge myfix into develop. Run tests.
    You discover your fix conflicts with another topic branch hisfix that your coworker merged into develop while you were working on your fix.
    Make more changes in the myfix branch to deal with these conflicts.
    Merge myfix into develop and run tests again.
    Everything works fine. Merge develop into master.
    Deploy to production from master any time, because you know it's stable.

For more details on this workflow, check out the Branching Workflows chapter in Pro Git.



# - to-do -


If you have a master branch and a develop and you need to merge changes from master into develop, and eventually merge everything from develop into master then the best approach is git rebase. It allows you to pull changes from master into your development branch, but leave all of your development work "on top of" (later in the commit log) the stuff from master. When your new work is complete, the merge back to master is then very straightforward. Be careful with rebase. If you're sharing your develop branch with anybody, rebase can make a mess of things. Rebase is good only for your own local branches. Rule of thumb, if you've pushed the branch to origin, don't use rebase. Instead, use merge.

This workflow works best for me:

	git checkout -b develop

...make some changes...

...notice master has been updated...

	git checkout master
	git pull

...bring those changes back into develop...

	git checkout develop
	git rebase master

...make some more changes...

...commit them to develop...

...merge them into master...

	git checkout master
	git pull git merge develop






REF <http://rogerdudler.github.com/git-guide/index.es.html>
REF <http://progit.org/book/es/ch1-3.html>
REF <http://book.git-scm.com/5_customizing_git.html>
REF servidor <http://wiki.dreamhost.com/Git>

git blame archivo

###Crear una nueva etiqueta
git tag "v1.3"
git push --tags

###Some nice aliases:
gb = git branch
gba = git branch -a
gc = git commit -v
gd = git diff | mate
gl = git pull
gp = git push
gst = git status

###Git aliases
st: git config -global alias.st status
ci: git config -global alias.ci commit
ca: git config -global alias.ca commit -a


git rebase command. Rebase allows you to easily change a series of commits, reordering, editing, or squashing commits together into a single commit.<http://help.github.com/rebase/>

[Licencia](LICENCIA.md)



flujo de trabajo:

tu repositorio local esta compuesto por tres "árboles" administrados por git. el primero es tu ""Directorio de trabajo"" el cual contiene los archivos. el segundo es el Index el cual actua como un área intermedia y finalmente el HEAD el cual apunta a el último commit realizado.

Puedes proponer cambios (agregarlos a el Index) usando
	git add <filename>

Para confirmar (hacer commit) estos cambios usa
	git commit -m "Commit message"
Ahora el archivo esta incluído en el HEAD de tu copia local, pero aún no en tu repositorio remoto.

Para enviar esos cambios a tu repositorio remoto ejecuta (Reemplaza master por la rama a la cual desees enviar tus cambios.)
	git push origin master

