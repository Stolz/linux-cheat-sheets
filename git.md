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

Por defecto push envía todas las ramas que existan en _origin_. Para hacer que por defecto push no implique todas las ramas sino solo la actual

    git config --global push.default current

### Ignorar archivos

Crear en la raíz de la copia de trabajo el fichero `.gitignore` con el listado de ficheros a ignorar.
Acepta comentarios con `#`, comodines con `*` y excepciones con `!`.

## Crear/importar repositorio

### Crear proyecto repositorio

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
- Don't forget to cd into your repo: `$ cd diaspora/ `
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

# - to-do -

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