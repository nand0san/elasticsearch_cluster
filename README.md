

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


**Inicar el cluster** en modo detached (la primera vez puede tardar en arrancar kibana varios minutos):

_**docker-compose up -d**_

Iniciar el cluster por stdout para ver posibles errores:  

_**docker-compose up**_

Detener los servicios:

_**docker-compose stop**_

Limpieza general de contenedores y redes creadas:

_**docker system prune -f**_

Eliminación de datos almacenamos del cluster (se puede hacer de manera mas visual accediendo a cerebro):

_**docker volume prune -f**_




## Visualización de datos:


Podemos acceder al entorno del cluster a través de kibana:

_**http://localhost:5601/**_

Para acceder a cerebro y gestionar el cluster:

_**http://localhost:9000**_

**Nota:** Para que cerebro conecte con el cluster usa la url: **http://elasticsearch1:9200**




## Para ingestión de datos:

Este cluster no está configurado con ningún agente de ingesta de datos como pudiera ser Beats o Logstash.

Configura los agentes beats o logstash (no incluidos en este repositorio) apuntando a los nodos:

Nodo 1: _**http://localhost:9201**_

Nodo 2: _**http://localhost:9202**_

Nodo 3: _**http://localhost:9203**_

**Nota:** da igual a que nodo hagas una query o a que nodo apuntes con los agentes de logstash o beats, elasticsearch tiene la propiedad de repartir la carga de trabajo automáticamente entre los nodos y se consultan mutuamente. Además si consultas cerebro puedes visualizar como se reparten entre cada nodo los shards de cada index y sus replicas.


## Problemas:


Si da error de memoria con un mensaje similar a este:

_ERROR: bootstrap checks failed max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]_

Hay que ampliar la memoria virtual del host en el que estas lanzando los contenedores al valor que pide, por ejemplo:

_**sudo sysctl -w vm.max_map_count=262144**_


