#!/bin/bash
#
# Ejercicio 5 Laboratorio Módulo1 Fundamentos Linux Bootcamp DevOps Lemoncode
# Alumno: Javier Rodríguez
#

# Variables
url=$1
palabra=$2
num_args=$#


if [ $num_args -ne 2 ]; then

        echo "Se necesitan únicamente dos parámetros para ejecutar este script"

else

        #Descarga de la web en un fichero de forma silenciosa
        curl -s "$url" -o web.html

        # Búsqueda silenciosa de la palabra pasada como parámetro
        grep -q "$palabra"  web.html

        # Almacenamos el exit code del comando anterior que será evaluado a continuación, si es 0 la palabra no fue encontrada si es diferente es encontrada y buscaremos las ocurrencias y cual es la primera línea en la que aparece
        Cod_Salida=$?

        if [ $Cod_Salida -ne 0 ]; then

                echo "NO se ha encontrado la palabra $palabra"
        else

                ocurrencias=$(grep -o "$palabra" web.html | grep -c "$palabra")
                num_linea=$(grep -m1 -n "$palabra" web.html | awk -F ":" '{print $1}')

                if [ "$ocurrencias" -eq 1 ]; then

                        echo "La palabra $palabra aparece 1 vez"
                        echo "Aparece únicamente en la línea $num_linea"

                else

                        echo "La palabra $palabra aparece $ocurrencias veces"
                        echo "Aparece por primera vez en la línea $num_linea"

                fi

        fi
fi


