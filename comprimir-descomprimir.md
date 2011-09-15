# Comprimir y descomprimir archivos en Linux

## Utilidades todo en uno

- [app-arch/atool](http://www.nongnu.org/atool/): Escrito in perl.“make sure everything is in 1 subdirectory” feature.
- [app-arch/unp](http://packages.qa.debian.org/u/unp.html): Tiene bash-completion.
- [dtrx](http://brettcsmith.org/2007/dtrx/): (No está en Portage). Escrito in python. “make sure everything is in 1 subdirectory” feature and -t (list) feature.
- [app-arch/p7zip](http://p7zip.sourceforge.net/): Además de comprimir en .7z puede descomprimir varios formatos comunes (7z, XZ, BZIP2, GZIP, TAR, ZIP, WIM, ARJ, CAB, CHM, CPIO, CramFS, DEB, DMG, FAT, HFS, ISO, LZH, LZMA, MBR, MSI, NSIS, NTFS, RAR, RPM, SquashFS, UDF, VHD, WIM, XAR and Z)

## Utilidades tradicionales

### <u>Ficheros .tar</u>

tar empaqueta varios archivos en uno solo, pero no comprime.

##### Instalar la herramienta

	emerge -­n tar

##### Empaquetar

	tar cvf archivo.tar ficheros

##### Desempaquetar

	tar ­xvf archivo.tar

##### Ver contenido
	tar ­tvf archivo.tar

### <u>Ficheros .gz</u>

gzip sólo comprime fichero a fichero, no empaqueta varios ficheros en uno ni comprime directorios.

##### Instalar la herramienta

	emerge -­n gzip

##### Comprimir

	gzip fichero

##### Descomprimir

	gzip -­d fichero.gz


### <u>Ficheros .bz2</u>

bzip2 sólo comprime fichero a fichero, no empaqueta varios ficheros en uno ni comprime directorios.

##### Instalar la herramienta

	emerge -­n bzip2

##### Comprimir

	bzip2 fichero

##### Descomprimir
	bzip2 -­d fichero.bz2


### <u><u>Ficheros .tar.gz</u></u>

Para comprimir varios ficheros y archivarlos en uno solo, al estilo de los compresores zip o rar hay que combinar tar con gzip o con bzip2.

##### Comprimir

	tar czvf archivo.tar.gz ficheros

##### Descomprimir

	tar xzvf archivo.tar.gz

##### Ver contenido

	tar tzvf archivo.tar.gz

### <u>Ficheros .tar.bz2</u>


##### Comprimir

	tar -­c ficheros | bzip2 > archivo.tar.bz2

##### Descomprimir

	tar jvxf archivo.tar.bz2

##### Ver contenido

	bzip2 -­dc archivo.tar.bz2 | tar ­-tv

### <u>Ficheros .zip</u>

##### Instalar las herramientas

	emerge -­n zip unzip

##### Comprimir

	zip archivo.zip ficheros

##### Descomprimir

	unzip archivo.zip

##### Ver contenido

	unzip -­v archivo.zip

### <u>Ficheros .rar</u>

##### Instalar la herramienta

	emerge -­n rar

##### Comprimir

	rar -a archivo.rar ficheros

##### Descomprimir

	rar -x archivo.rar

##### Ver contenido

	rar l archivo.rar

o

	rar v archivo.rar

### <u>Ficheros .7z</u>

##### Instalar la herramienta

	emerge -­n p7zip

##### Comprimir

Usando 4 porcesadores/cores y dividiendo en trozos de 80MB

		7z a -t7z archivo.7z ficheros -m0=bzip2 -v80m  -mmt=4

##### Descomprimir

	7z x archivo.7z

### <u>Ficheros .lha</u>

##### Instalar la herramienta

	emerge -­n lha

##### Comprimir

	lha -a archivo.lha ficheros

##### Descomprimir

	lha -x archivo.lha

##### Ver contenido

	lha -v archivo.lha o # lha l archivo.lha

### <u>Ficheros .arj</u>

##### Instalar las herramientas

	emerge -­n arj unarj

##### Comprimir

	arj a archivo.arj ficheros

##### Descomprimir

	unarj archivo.arj

o

	arj -x archivo.arj


##### Ver contenido

	arj -v archivo.arj

o

	arj -l archivo.arj

### <u>Ficheros .zoo</u>

##### Instalar la herramienta

	emerge -­n zoo

##### Comprimir

	zoo -a archivo.zoo ficheros

##### Descomprimir

	zoo -x archivo.zoo

##### Ver contenido

	zoo -L archivo.zoo

o

	zoo -v archivo.zoo