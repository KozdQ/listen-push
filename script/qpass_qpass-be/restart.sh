#!/usr/bin/env bash
set -e

docker pull qpass/qpass-be:latest
docker stop qpass-public
docker start mysql
docker container rm qpass-public
docker run --name qpass-public -dp 80:8080 qpass/qpass-be:latest