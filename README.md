

# Elasticsearch Cluster


Cluster en docker compose para iniciar tres nodos y kibana.

Incluye **cerebro** para monitorización interna de shards y réplicas.

El cluster está dotado de persistencia de datos, aunque se paren los contenedores y se eliminen. Esto se ha hecho a través de los volúmenes gestionados por la plataforma docker según vemos al final de su archivo docker-compose.yml.


## macOS

Testado en una máquina MacBook:

**uname -a**: Darwin MacBook-Pro.local 18.6.0 Darwin Kernel Version 18.6.0: Thu Apr 25 23:16:27 PDT 2019; root:xnu-4903.261.4~2/RELEASE_X86_64 x86_64
mojave 10.14.5
portatil con 16gb de ram procesador i7

## Ubuntu 18.04

Testado en Ubuntu.

Distributor ID:	Ubuntu
Description:	Ubuntu 18.04.2 LTS
Release:	18.04
Codename:	bionic


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

_**docker logs dec6afdc666f**_

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

Este cluster está configurado con *filebeat* y *logstash* para autoparsear csv. 

Las configuraciones por defecto admiten logs en csv separados por comas con línea de cabecera. No está previsto multilinea.

Para parsear los logs csv, crea una carpeta llamada _**csvtoparse**_ en la raiz del proyecto e introduce los logs en la carpeta, verifica que tienen la extension csv. 

En el archivo de configuración de logstash y de filebeat, se etiquetan los csv en función de la subcarpeta en la que se encuentren dentro de _**"csvtoparse"**_, en concreto, si estań en la carpeta dns o proxy, aplicará un parseo diferente conforme a las columnas que yo utilizo y que a mi me convienen.

De esta manera, dependiendo de la estructura de columnas que tenga el csv, lo dejas en una subcarpeta u otra y así puedes crear parseos diferentes en funcion de en que subcarpeta los encuentra filebeat.

Por otro lado, los csv que se encuentren directamente en la carpeta _**csvtoparse**_ serán analizados con la función autoparse.

Los filtros preconfigurados en logstash.conf incluyen la opción de parsear por fechas procedentes de una columna llamada fec_operacion en lugar de **@timestamp**, que es la fecha de ingesta por elasticshearch, así no se pierde la fecha real del evento. A continuación pongo un extracto de la configuración para que puedas ver como lo parseo:

``` 
  mutate {
      gsub => [ 'message', '\"', '' ]
    }
    csv {
      separator => ","
      autodetect_column_names => true
      autogenerate_column_names => true        # use only if csv file has some no titled columns
      skip_header => false
    }
    date {
      match => [ "fec_operacion", "yyyy-MM-dd' 'HH:mm:ss'.'SSSSSSSSS" ]
      target => "fec_operacion"
    }
  }
```

La configuración actual te va a crear un index diferente por cada archivo csv analizado, pero con nombre estructurado de tal manera que puedas agrupar todo en un solo index si quieres.

Para analizar con mas exactitud diversos tipos de csv habría que construir un filtro grok a medida de cada csv en el archivo logstash.conf utilizando la documentacion oficial.

Ayuda: https://grokconstructor.appspot.com/

Configura los agentes beats o logstash de otros host o externos apuntando a los nodos:

Nodo 1: _**http://localhost:9201**_

Nodo 2: _**http://localhost:9202**_

Nodo 3: _**http://localhost:9203**_

**Nota:** da igual a que nodo hagas una query o a que nodo apuntes con los agentes de logstash o beats, elasticsearch tiene la propiedad de repartir la carga de trabajo automáticamente entre los nodos y se consultan mutuamente. Además si consultas cerebro puedes visualizar como se reparten entre cada nodo los shards de cada index y sus replicas.

## Para exportación de datos:

En la ventana de kibana (_**http://localhost:5601**_), una vez que hayas aplicado los filtros de búsqueda e intervalos de tiempo, debes guardar ese estado de búsqueda para poderlo exportar después, se hace pulsando "Save" en la parte superior de "Discover". Una vez que lo has guardado pulsa "Share" en la parte superior del apartado "Discover", observarás que aparece "CSV reports" para poder exportar las búsquedas guardadas anteriormente.

## Problemas:

Si da error de memoria con un mensaje similar a este:

_ERROR: bootstrap checks failed max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]_

Hay que ampliar la memoria virtual del host en el que estas lanzando los contenedores al valor que pide, por ejemplo:

_**sudo sysctl -w vm.max_map_count=262144**_
