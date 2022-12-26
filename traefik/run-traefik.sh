#!/bin/bash

docker rm -f traefik

docker run -d --restart always -p 8080:8080 -p 80:80 -p 443:443    \
   -v $PWD/config.yaml:/etc/traefik/traefik.yaml \
   -v $PWD/traefik.d/:/etc/traefik.d/   \
   -v $PWD/ssl/:/etc/traefik-ssl/   \
   -v $PWD/acme.json:/data/acme.json   \
   --name traefik \
   --network eagle \
   traefik:v2.7
