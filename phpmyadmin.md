# phpMyAdmin

__Nota:__ Las palabras en mayúsculas deben ser reemplazas por los valores adecuados en cada caso

## Instalación desde cero

### Obtener la última versión

	emerge -av phpmyadmin

### Averigual el número de version para usar en el siguiente comando

	webapp-config --lui

### Instalar el vhost 

Por ejemplo para instalarlo dentro del vhost `example.com` en la carpeta phpMyAdmin (ruta absoluta  `/var/www/example.com/htdocs/phpMyAdmin/`)

	webapp-config -I -h example.com -d phpMyAdmin phpmyadmin VERSION_DEL_PASO_ANTERIOR

### Crear el archivo de configuración

Creamos el fichero `/var/www/example.com/htdocs/phpMyAdmin/config.inc.php` con el siguiente contenido:

	<?php

	$cfg['blowfish_secret'] = 'PONER_AQUI_UNA_FRASE_ALEATORIA_DE_HASTA_46_CARACTERES_QUE_SE_USARA_PARA_CIFRAR_LA_CONTRASENA_DE_LA_COOKIE';

	$i=1;
	$cfg['Servers'][$i]['verbose'] = 'BBDD de example.com';
	$cfg['Servers'][$i]['auth_type'] = 'cookie';
	$cfg['Servers'][$i]['hide_db'] = 'information_schema';
	$cfg['Servers'][$i]['connect_type'] = 'socket';

	/* User for advanced features */
	$cfg['Servers'][$i]['controluser'] = 'pma';
	$cfg['Servers'][$i]['controlpass'] = 'foobar';

	/* Advanced phpMyAdmin features */
	$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
	$cfg['Servers'][$i]['bookmarktable'] = 'pma_bookmark';
	$cfg['Servers'][$i]['relation'] = 'pma_relation';
	$cfg['Servers'][$i]['table_info'] = 'pma_table_info';
	$cfg['Servers'][$i]['table_coords'] = 'pma_table_coords';
	$cfg['Servers'][$i]['pdf_pages'] = 'pma_pdf_pages';
	$cfg['Servers'][$i]['column_info'] = 'pma_column_info';
	$cfg['Servers'][$i]['history'] = 'pma_history';
	$cfg['Servers'][$i]['tracking'] = 'pma_tracking';
	$cfg['Servers'][$i]['designer_coords'] = 'pma_designer_coords';
	$cfg['Servers'][$i]['userconfig'] = 'pma_userconfig';


### Crear el usario y la base de datos para guardar la configuración de phpmyadmin y tener opciones avanzadas

`foobar` es la contraseña que hemos indicado antes en la variable `controlpass` del archivo `config.inc.php`

	mysql -p
	CREATE DATABASE IF NOT EXISTS `phpmyadmin`  DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
	GRANT SELECT, INSERT, DELETE, UPDATE ON `phpmyadmin`.* TO 'pma'@localhost IDENTIFIED BY 'foobar';
	flush privileges;
	USE phpmyadmin;
	source /var/www/example.com/htdocs/phpMyAdmin/scripts/create_tables.sql
	quit


## Actualización

###  Obtener la última versión

	emerge -uav phpmyadmin

###  Averigual el número de version para usar en el siguiente comando

	webapp-config --lui

### Actualizar la instalacion

	webapp-config -U -h example.com -d phpMyAdmin phpmyadmin VERSION_DEL_PASO_ANTERIOR

### Actualizar los archivos de configuración

	CONFIG_PROTECT="/var/www/example.com/htdocs/phpMyAdmin/libraries" etc-update

### Desinstalar version antigua

	emerge --prune -a  phpmyadmin





















