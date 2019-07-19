

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

-disk image size: 80 GB (al gusto)

-4 processors

-RAM memory: 12GB

-swap 1GB (no lo usamos en elasticsearch con este docker-compose.yml)

-Versión de elasticsearch y kibana 6.5.4



## Uso básico:


**Inicar el cluster** en modo detached (puede tardar en arrancar dependiendo de los datos almacenados):

_**docker-compose up -d**_

Iniciar el cluster por stdout para ver posibles errores:  

_**docker-compose up**_

Si hay errores que requieren más atención, puedes mirarlos viendo el ID de los contenedores para luego ver sus logs, primero con el comando:

_**docker ps**_

Después, con el ID del contenedor puedes ver sus logs a fondo:

_**docker logs 32423413123**_

También hay un script de limpieza para agilizar las pruebas, usa _bash stop.sh_ o usa por separado:

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

Este cluster se está configurado con *filebeat* y *logstash* para autoparsear csv. Las configuraciones por defecto admiten logs en csv separados por comas con línea de cabecera. No está previsto multilinea.

Para parsear los logs csv, introducelos en la carpeta "csvtoparse" con las extension csv.

Se pueden analizar varios csv, pero del mismo formato de columnas, para analizar diversos tipos de csv habría que construir un filtro grok a medida en el archivo logstash.conf con la documentacion oficial.

Ayuda: https://grokconstructor.appspot.com/

Configura los agentes beats o logstash de otros host o externos apuntando a los nodos:

Nodo 1: _**http://localhost:9201**_

Nodo 2: _**http://localhost:9202**_

Nodo 3: _**http://localhost:9203**_

**Nota:** da igual a que nodo hagas una query o a que nodo apuntes con los agentes de logstash o beats, elasticsearch tiene la propiedad de repartir la carga de trabajo automáticamente entre los nodos y se consultan mutuamente. Además si consultas cerebro puedes visualizar como se reparten entre cada nodo los shards de cada index y sus replicas.


## Problemas:

Si da error de memoria con un mensaje similar a este:

_ERROR: bootstrap checks failed max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]_

Hay que ampliar la memoria virtual del host en el que estas lanzando los contenedores al valor que pide, por ejemplo:

_**sudo sysctl -w vm.max_map_count=262144**_
