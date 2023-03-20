#!/usr/bin/env bash

docker run -d --name mysql-local -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 mysql:8.0

./mvnw package

docker stop petclinic
docker rm petclinic

docker build -t registry.whatap.io:5000/hsnam/petclinic:0316 .
docker run -d -p 8080:8080 \
    --name petclinic \
    --add-host mysql.local:192.168.250.109 \
    registry.whatap.io:5000/hsnam/petclinic:0316

docker logs petclinic -f
