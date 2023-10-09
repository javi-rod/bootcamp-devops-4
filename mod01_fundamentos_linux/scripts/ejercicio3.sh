#!/bin/bash
#
# Ejercicio 3 Laboratorio Módulo1 Fundamentos Linux Bootcamp DevOps Lemoncode
# Alumno: Javier Rodríguez
#

# Controlar el número de parámetros
if [ $# -gt 1 ]; then	
	
	echo "ERROR!!Se necesita un sólo parámetro!!"
	
else
	
	# Evaluar si se ha introducido un parámetro para asignar un valor concreto a la variable texto
	if [ $# -eq 0 ]; then
        
		texto='Que me gusta la bash!!!!'

	else

        texto=$1

	fi
	
# Creamos directorio foo y subdirectorios dummy y empty
mkdir -p foo/dummy/ foo/empty 

# Creamos los ficheros file1.txt y file2.txt
touch foo/dummy/file1.txt foo/dummy/file2.txt

# Hacemos un echo de la variable texto y lo redireccionamos a file1.txt
echo "$texto" > foo/dummy/file1.txt 

# Ahora volcamos el contenido file1.txt a file2.txt
cat foo/dummy/file1.txt > foo/dummy/file2.txt

# Movemos file2 
mv foo/dummy/file2.txt foo/empty/

fi