#!/bin/bash

# files="-f docker-compose.yml -f compose-es.yml -f compose-db.yml -f compose-mq.yml"
files="-f docker-compose.yml -f compose-es.yml -f compose-db.yml -f compose-mq.yml -f compose-app.yml"

docker-compose $files down
docker-compose $files up -d