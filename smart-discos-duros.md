# S.M.A.R.T en Linux

## Self-Monitoring, Analysis and Reporting Technology

__NOTA:__ [Como anular sectores defectousos](http://smartmontools.sourceforge.net/BadBlockHowTo.txt)

Antes de nada asegurate de tener S.M.A.R.T en la BIOS.

### Instalar

	emerge -anv smartmontools

### Para saber si el disco soporta S.M.A.R.T

	smartctl -i /dev/sda

La penúltima linea indica si el disco lo soporta.
La última linea indica si el disco lo tiene activado.

Si no lo tiene activado ejecutar

	smartctl -s on /dev/sda

### Para conocer el estado actual

	smartctl -H  /dev/sda

Si pone `PASSED` el disco funciona como toca (aunque puede tener sectores malos).

Si pone `FAILED` el disco ya está fallando.

### Para ver el listado de los 5 últimos errores no triviales detectados durante la vida del disco

	smartctl -l error /dev/sda

### Para motitorizar los discos

	to-do /etc/smartd.conf

## TESTS

Solo se puede ejecutar un test a la vez. Si se inicia un test los que estuvieran en ejecución se abortan.

Para saber los tests que soporta nuestro disco y para ver cuales de ellos están en ejecución y cuanto les falta para acabar

	smartctl -c /dev/sda

### Test offline inmediato

	smartctl -t offline /dev/sda

Para ver el resultado

	smartctl -l error /dev/sda

### Test corto y largo

Son el mismo tipo de test pero el largo es mas exhaustivo. Este test comprueba el desempeño eléctrico, mecánico y de lectura.

	smartctl -t short /dev/sda
	smartctl -t long /dev/sda

para ver el resultado

	smartctl -l selftest /dev/sda

### Test de transporte

Diseñado para detectar fallos producidos durante el transporte

	smartctl -t conveyance /dev/sda

para ver el resultado

	smartctl -l selftest /dev/sda

