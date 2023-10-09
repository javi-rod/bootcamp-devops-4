#!/bin/bash
#
# Ejercicio 4 Laboratorio Módulo1 Fundamentos Linux Bootcamp DevOps Lemoncode
# Alumno: Javier Rodríguez
#

# Constante URL
url='https://lemoncode.net/'

if [ $# -ne 1 ];then 

	 echo "ERROR: Debe introducir una única palabra a buscar"
	
else

	# Descarga de la web en un fichero de forma silenciosa
	curl -s $url -o web.html

	# Búsqueda silenciosa de la palabra pasada como parámetro
	grep -q "$1"  web.html

	# Almacenamos el exit code del comando anterior
	# 0: palabra no encontrada
	# Distinto de 0: palabra encontrada
	Cod_Salida=$?

	# Si no hay ocurrencias se muestra mensaje, si se encuentra la palabra se almacena el número de ocurrencias y la primera línea en la que aparece la palabra
	if [ $Cod_Salida -ne 0 ]; then

			echo "NO se ha encontrado la palabra $1"
	else

			ocurrencias=$(grep -o "$1" web.html | grep -c "$1")
			echo "La palabra $1 aparece $ocurrencias veces"

			num_linea=$(grep -m1 -n "$1" web.html | awk -F ":" '{print $1}')
			echo "Aparece por primera vez en la línea $num_linea"
	fi
fi