# Resumen de Rsync

## Parámetros más comunes

<dl>
	<dt>--archive</dt>
		<dd> conservar todos los permisos,propietarios y copiar los enlaces simbólicos</dd>

	<dt>--delete</dt>
		<dd> borrar del destino los archivos que hayan sido eliminados del origen</dd>

	<dt>--delete-excluded</dt>
		<dd> borrar del destino los archivos que hayan sido excluidos del origen (implica --delete)</dd>

	<dt>--dry-run</dt>
		<dd> solo emular lo que se va a hacer, sin llegar a hacerlo</dd>

	<dt>--exclude</dt>
		<dd> no hacer sincronización de los directorios/archivos indicados a continuación de este parametro (separados por comas)</dd>

	<dt>--exclude-from</dt>
		<dd> como lo anterior pero lee los directorios/archivos del archivo indicado a continuación de este parametro.Si en dicho archivo ponermos /dir/ no incluira /dir/, pero si ponemos /dir/* sí inlcuira /dir/ pero no su contenido</dd>

	<dt>--human-readable</dt>
		<dd> mostrar los valeres numéricos de tamañas de forma entendible por humanos</dd>

	<dt>--links</dt>
		<dd> copiar los enlaces simbólicos</dd>

	<dt>--progress</dt>
		<dd> muestra un porcentaje de la transferencia del archivo (implica --verbose)</dd>

	<dt>--recursive</dt>
		<dd> copiar recursivamente los directorios</dd>

	<dt>--stats</dt>
		<dd> mostrar un resumen de lo que se ha hecho</dd>

	<dt>--verbose</dt>
		<dd> mostrar información de lo que se va a hacer</dd>
</dl>


## Deteccion de cambios

Por defecto rsync considera iguales dos archivos que tienen el mismo tamaño y la misma fecha de modificación. Si cualquiera de las dos cosas es distinta, considera que el archivo debe actualizarse. Este comportamiento se puede cambiar con estas opciones:

<dl>
	<dt>--ignore-times</dt>
		<dd> anula el comportamiento por defecto, es decir, actualiza todos los archivos aunque no hayan cambiado de fecha ni tamaño.

	<dt>--size-only</dt>
		<dd> anula la parte del comportamiento por defecto relativa a las fechas, es decir, solo se actualizan los archivos que hayan cambiado de tamaño. Si han cambiado de fecha pero no de tamaño no se actualizan.

	<dt>--checksum</dt>
		<dd> realiza un checksum de todos los ficheros que no hayan cambiado de tamaño para verificar si han cambiado el contenido. Es muy lenta.
</dl>

### Triple asterisco

Ejemplo del uso de triple asterisco (***) cuando el origen es un recurso de un servidor rsync en vez de tunel SSH.

Por ejemplo, sincronizar solo el directorio "backup" de todos los usuarios, es decir, de ...

- user1/
	- non_important_file1.txt
	- non_important_folder1/
    - backup/
        - important_file1.txt
- user2/
	- non_important_file2.txt
	- non_important_folder2/
    - backup/
        - important_file2.txt


copiar solo ...

- user1/
    - backup/
        - important_file1.txt
- user2/
    - backup/
        - important_file2.txt

Comando:

	rsync [common options] --prune-empty-dirs --include '*/' --include '*/backup/***' --exclude '*'
