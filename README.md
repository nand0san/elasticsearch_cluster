

# Elasticsearch Cluster


Cluster en docker compose para iniciar tres nodos y kibana.

El cluster está dotado de persistencia de datos, aunque se paren los contenedores y se eliminen. Esto se ha hecho a través de los volúmenes gestionados por la plataforma docker según vemos al final de su archivo docker-compose.yml.


## macOS

Testado en Windows 11 Desktop 4.6.1 (76265) :


## Requerimientos:

-disk image size: 80 GB (al gusto)

-4 processors

-RAM memory: 12GB

-Versión de elasticsearch y kibana 8.1.2



## Uso básico:


**Inicar el cluster** en modo detached (puede tardar en arrancar dependiendo de los datos almacenados):

_**docker-compose up -d**_

Iniciar el cluster por stdout para ver posibles errores:  

_**docker-compose up**_

Si hay errores que requieren más atención, puedes mirarlos viendo el ID de los contenedores para luego ver sus logs, primero con el comando:

_**docker ps**_

Después, con el ID del contenedor puedes ver sus logs a fondo:

_**docker logs dec6afdc666f**_

También hay un script de limpieza para agilizar las pruebas, usa _bash stop.sh_ o usa por separado:

_**docker-compose stop**_

Limpieza general de contenedores y redes creadas:

_**docker system prune -f**_

Eliminación de datos almacenamos del cluster:

_**docker volume prune -f**_


## Visualización de datos:


Podemos acceder al entorno del cluster a través de kibana:

_**http://localhost:5601/**_

## Contraseñas:

Se pueden modificar en el archivo .env, por defecto la contraseñas sería `password`.

## Para ingestión de datos:

Enviar los datos al puerto 9200, bien desde algún agente beats, o bien, por ejemplo, desde syslong-ng.

Lo recomendable sería levantar un logstash, pero actualmente no está contemplado.


## Para exportación de datos:

En la ventana de kibana (_**http://localhost:5601**_), una vez que hayas aplicado los filtros de búsqueda e intervalos de tiempo, debes guardar ese estado de búsqueda para poderlo exportar después, se hace pulsando "Save" en la parte superior de "Discover". Una vez que lo has guardado pulsa "Share" en la parte superior del apartado "Discover", observarás que aparece "CSV reports" para poder exportar las búsquedas guardadas anteriormente.

## Problemas (linux):

Si da error de memoria con un mensaje similar a este:

_ERROR: bootstrap checks failed max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]_

Hay que ampliar la memoria virtual del host en el que estas lanzando los contenedores al valor que pide, por ejemplo:

_**sudo sysctl -w vm.max_map_count=262144**_
