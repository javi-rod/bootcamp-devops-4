#!/bin/bash
#
# Ejercicio 3 Laboratorio Módulo1 Fundamentos Linux Bootcamp DevOps Lemoncode
# Alumno: Javier Rodríguez
#

# Evaluar si se ha introducido un argumento para asignar un valor concreto a la variable texto
if [ $# -eq 0 ];
then
        texto='Que me gusta la bash!!!!'
else

        texto=$1
fi
# Tras la evaluación, creamos directorios y subdirectorios, introducimos el valor de la variable texto  en file1.txt, luego copiamos su contenido a file2.txt para terminar moviendo el fichero al directorio empty
 mkdir -p foo/dummy/ foo/empty && touch foo/dummy/file1.txt foo/dummy/file2.txt && echo "$texto" > foo/dummy/file1.txt && cp foo/dummy/file1.txt foo/dummy/file2.txt && mv foo/dummy/file2.txt foo/empty/
