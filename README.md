

# Elasticsearch Cluster


Cluster en docker compose para iniciar tres nodos y kibana. 

Incluye **cerebro** para monitorización interna de shards y réplicas. 

El cluster está dotado de persistencia de datos, aunque se paren los contenedores y se eliminen. Esto se ha hecho a través de los volúmenes gestionados por la plataforma docker según vemos al final de su archivo docker-compose.yml.


## macOS

Testado en una máquina MacBook:

**uname -a**: Darwin MacBook-Pro.local 18.6.0 Darwin Kernel Version 18.6.0: Thu Apr 25 23:16:27 PDT 2019; root:xnu-4903.261.4~2/RELEASE_X86_64 x86_64

mojave 10.14.5

portatil con 16gb de ram procesador i7


## Requerimientos:

-docker versión: Docker version 18.09.2, build 6247962

-docker compose versión: docker-compose version 1.23.2, build 1110ad01

-disk image size: 80 GB

-4 processors

-RAM memory: 10GB

-swap 1GB (no lo usamos en elasticsearch con este docker-compose.yml)

-Versión de elasticsearch y kibana 6.5.4



## Uso básico:


Inicar el cluster en modo detached (la primera vez puede tardar en arrancar kibana varios minutos):

__**docker-compose up -d**__


Iniciar el cluster por stout para ver posibles errores:  

__**docker-compose up**__


Detener los servicios:

__**docker-compose stop**__

Limpieza general de contenedores y redes creadas:

__**docker system prune -f**__

Eliminación de datos almacenamos del cluster (se puede hacer de manera mas visual accediendo a cerebro):

__**docker volume prune -f**__


## Visualización de datos:


Podemos acceder al entorno del cluster a través de kibana:

__**http://localhost:5601/**__

Para acceder a cerebro y gestionar el cluster:

__**http://localhost:9000**__

__Nota: Para que cerebro conecte con el cluster emplear la url: **http://elasticsearch1:9200**__


## Para ingestión de datos:

Este cluster no está configurado con ningún agente de ingesta de datos como pudiera ser Beats o Logstash.

Configura los agentes beats o logstash (no incluidos en este repositorio) apuntando a los nodos:

Nodo 1: __**http://localhost:9201**__

Nodo 2: __**http://localhost:9202**__

Nodo3: __**http://localhost:9203**__

__Nota: da igual a que nodo te conectes o a que nodo apuntes con los logstash o beats empleados, elasticsearch tiene la propiedad de repartir la carga de trabajo automáticamente y con cerebro puedes visualizar como se reparte cada nodo los shards de cada index y sus replicas.


## Problemas:


Si da error de memoria con un mensaje similar a este:

__ERROR: bootstrap checks failed max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]__

Hay que ampliar la memoria virtual del host en el que estas lanzando los contenedores al valor que pide, por ejemplo:

__sudo sysctl -w vm.max_map_count=262144__


