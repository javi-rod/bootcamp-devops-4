# LABORATORIO MÓDULO 2 - CONTENEDORES DOCKER

## Ejercicio 1

Dockeriza la aplicación dentro de lemoncode-challenge, la cual está compuesta de 3 partes:

- Un front-end con Node.js

- Un backend en .NET (dotnet-stack) o en Node.js (node-stack) que utiliza un MongoDB para almacenar la información.

- El MongoDB donde se almacena la información en una base de datos.

Nota: como has podido comprobar, el directorio lemoncode-challenge tiene dos carpetas: dotnet-stack y node-stack. En ambos casos el frontend es el mismo, sólo cambia el backend. Usa el stack que prefieras.

Requisitos del ejercicio:

1. Los tres componentes deben estar en una red llamada lemoncode-challenge.
2. El backend debe comunicarse con el mongodb a través de esta URL mongodb://some-mongo:27017.
3. El front-end debe comunicarse con la api a través de http://topics-api:5000/api/topics.
4. El front-end debe estar mapeado con el host para ser accesible a través del puerto 8080.
5. El MongoDB debe almacenar la información que va generando en un volumen, mapeado a la ruta /data/db.
6. Este debe de tener una base de datos llamada TopicstoreDb con una colección llamada Topics.

La colección Topics debe tener esta estructura:

```
    {
        "_id": { "$oid" : "5fa2ca6abe7a379ec4234883" },
        "Name" : "Contenedores"
    }
```

¡Añade varios registros!

**Tip para backend**: Antes de intentar contenerizar y llevar a cabo todos los pasos del ejercicio se recomienda intentar ejecutar la aplicación sin hacer cambios en ella. En este caso, lo único que es posible que “no tengamos a mano” es el MongoDB. Por lo que empieza por crear este en Docker, usa un cliente como el que vimos en el primer día de clase (MongoDB Compass) para añadir datos que pueda devolver la API.

Nota: es más fácil si abres Visual Studio Code desde la carpeta backend para hacer las pruebas y las modificaciones que si te abres desde la raíz del repo. Para ejecutar este código solo debes lanzar dotnet run si usas el stack de .NET, o npm install && npm start si usas el stack de Node.js.

**Tip para frontend**: Para ejecutar el frontend abre esta carpeta en VS Code y ejecuta primero npm install. Una vez instaladas las dependencias ya puedes ejecutarla con npm start.

**RESOLUCIÓN EJERCICIO**

A continuación se describen los pasos seguidos para resolver el ejercicio

- CREAR RED LEMONCODE-CHALLENGE

`$ docker network create lemoncode-challenge`

![Crear network](/mod02_contenedores_docker/img/create_network.jpg)

- CREAR VOLUMEN DATA

`$ docker volume create data`

![Crear volumen](/mod02_contenedores_docker/img/create_volumen.jpg)

- CREAR CONTENEDOR MONGO CON VOL Y RED CREADAS EN LOS PASOS ANTERIORES

`$ docker run -d --name some-mongo --mount source=data,target=/data/db --network=lemoncode-challenge mongo`

- CREAR DOCKERFILE BACKEND

NOTA: El dockerfile está disponible en el directorio lemoncode-challenge > node-stack > backend

![Dockerfile backend](/mod02_contenedores_docker/img/dockerfile_backend.jpg)

- CREAR DOCKERIGNORE PARA BACKEND

![dockerignore backend](/mod02_contenedores_docker/img/dockerignore_backend.jpg)

- CREAR DOCKERFILE FRONTEND

NOTA: El dockerfile está disponible en el directorio lemoncode-challenge > node-stack > frontend

![Dockerfile frontend](/mod02_contenedores_docker/img/dockerfile_frontend.jpg)

- CREAR DOCKERIGNORE PARA FRONTEND

![dockerignore frontend](/mod02_contenedores_docker/img/dockerignore_frontend.jpg)

- CREAR IMAGEN BACKEND

`$ docker build -t backend .`

![build backend](/mod02_contenedores_docker/img/build_backend.jpg)

- CREAR IMAGEN FRONTEND

`$ docker build -t frontend .`

![build frontend](/mod02_contenedores_docker/img/build_frontend.jpg)

- COMPROBAR QUE SE HAN CREADO IMAGENES

`$ docker images`

![docker images](/mod02_contenedores_docker/img/images.jpg)

- CREAR CONTENEDOR BACKEND topics-api

`$ docker run -d -e DATABASE_URL="mongodb://some-mongo:27017" --name  topics-api --network=lemoncode-challenge backend`

![contenedor backend](/mod02_contenedores_docker/img/contenedor_backend.jpg)

- CREAR CONTENEDOR FRONTEND topics accesible por el puerto 8080

`$ docker run -d --name topics -p 8080:3000 -e API_URI=http://topics-api:5000/api/topics --network lemoncode-challenge frontend`

![contenedor frontend](/mod02_contenedores_docker/img/contenedor_frontend.jpg)

- COMPROBAR QUE ESTÁ FUNCIONANDO

Si abrimos el navegador web y ejecutamos http://localhost:8080 veremos que funciona pero no tenemos datos.

![localhost8080](/mod02_contenedores_docker/img/localhost_8080.jpg)

Para añadir datos debemos hacer lo pasos siguientes:

- Ejecutamos un `docker exec -it some-mongo bash` para abrir una shell en el contenedor de mongo
- Ejecutamos la línea de comandos de mongo con `mongosh`
- Ejecutamos un `use TopicstoreDb` para crear la base de datos
- Ejecutamos un `db.Topics.insert ( {"_id": "$oid", "Name" : "Contenedores"} )` para añadir datos (esto crea automáticamente la colección Topics)

![Insertar datos en mongo](/mod02_contenedores_docker/img/insert_data_mongo.jpg)

Si ahora volvemos al navegador y refrescamos

![localhost8080 con datos](/mod02_contenedores_docker/img/localhost_8080_data.jpg)

## Ejercicio 2

Ahora que ya tienes la aplicación del ejercicio 1 dockerizada, utiliza Docker Compose para lanzar todas las piezas a través de este. Debes plasmar todo lo necesario para que esta funcione como se espera: la red que utilizan, el volumen que necesita MongoDB, las variables de entorno, el puerto que expone la web y la API. Además debes indicar qué comandos utilizarías para levantar el entorno, pararlo y eliminarlo.

**RESOLUCIÓN EJERCICIO**

- CREAR DOCKER COMPOSE

NOTA: El docker-compose está disponible en el directorio lemoncode-challenge

![docker-compose](/mod02_contenedores_docker/img/docker_compose.jpg)

- LEVANTAR ENTORNO

`$ docker compose up`

![docker-compose up](/mod02_contenedores_docker/img/docker_compose_up.jpg)

Comprobamos que se han levantado los contenedores

![contenedores corriendo](/mod02_contenedores_docker/img/docker_ps_compose.jpg)

Abrimos en un navegador localhost:8080

![localhost8080](/mod02_contenedores_docker/img/localhost_8080_compose.jpg)

Ahora vamos a cargar datos para ello hacemos lo siguiente:

- Ejecutamos un `docker exec -it lemoncode-challenge-mongodb-1 bash` para abrir una shell en el contenedor de mongo
- Ejecutamos la línea de comandos de mongo con `mongosh`
- Ejecutamos un `use TopicstoreDb` para crear la base de datos
- Ejecutamos un `db.Topics.insert ( {"_id": "$oid", "Name" : "Docker"} )` para añadir datos (esto crea automáticamente la colección Topics)

![Cargar Datos en Mongo](/mod02_contenedores_docker/img/insert_data_mongo_compose.jpg)

Refrescamos la página y vemos los datos.

![localhost8080 con datos](/mod02_contenedores_docker/img/localhost_8080_compose_datos.jpg)

- PARAR ENTORNO

`$ docker compose stop`

Ejecutamos también un docker ps -a para ver que se han parado

![docker-compose stop](/mod02_contenedores_docker/img/docker_compose_stop.jpg)

- ELIMINAR CONTENEDORES PARADOS

`$ docker compose rm`

![docker compose rm](/mod02_contenedores_docker/img/docker_compose_rm.jpg)

En el caso que los contenedores estuvieran corriendo y deseáramos pararlos y eliminarlos, ejecutaríamos el comando siguiente.

`$ docker compose down`

![docker compose down](/mod02_contenedores_docker/img/docker_compose_down.jpg)

Como se aprecia en la imagen no sólo se eliminan los contenedores, también se elimina la red.

Antes de finalizar, vamos a mejorar el docker-compose añadiendo el campo depends_on en el frontend y backend. Esta opción establece el orden de creación y eliminación como vamos a ver a continuación.

![docker compose 2](/mod02_contenedores_docker/img/docker_compose2.jpg)

Cuando ejecutamos `docker compose -f docker-compose-v2.yml up` para levantar el entorno, si comparamos con la salida del que se ejecuta en pasos anteriores, se aprecia como se crea primero el contenedor de mongo, luego el de backend y por último el de frontend, cración más lógica y no aleatoria gracias a la opción de depends_on. El frontend dependerá del backend y éste del mongo.

![docker compose 2 up ](/mod02_contenedores_docker/img/docker_compose2_up.jpg)

Ahora si eliminamos el entorno ejecutando `docker compose -f docker-compose-v2.yml down` veremos que el proceso es inverso, pimero se elimina el contenedor de frontend, luego el backend y por último el de mongo.

![docker compose 2 down ](/mod02_contenedores_docker/img/docker_compose2_down.jpg)

Por último aclarar que se usa la opción -f al ejecutar el docker-compose para indicar el fichero que debe usar.
