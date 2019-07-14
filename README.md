

Elasticsearch Cluster
=====================


Cluster en docker compose para iniciar un cluster de tres nodos y kibana con cerebro para monitorización interna de shards y réplcias.


##macOS
Testado en una máquina MacBook:

-uname -a: Darwin MacBook-Pro.local 18.6.0 Darwin Kernel Version 18.6.0: Thu Apr 25 23:16:27 PDT 2019; root:xnu-4903.261.4~2/RELEASE_X86_64 x86_64
-mojave 10.14.5


Requerimientos:

-docker versión: Docker version 18.09.2, build 6247962
-docker compose versión: docker-compose version 1.23.2, build 1110ad01
-disk image size: 80 GB
-4 processors
-RAM memory: 10GB
-swap 1GB (no lo usamos en elasticsearch con este docker-compose.yml)




