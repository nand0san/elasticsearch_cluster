#!/bin/bash
#docker-compose down
#docker rmi $(docker images -q)
docker kill $(docker ps -a -q)
docker system prune -f
docker network prune -f
docker volume prune -f
