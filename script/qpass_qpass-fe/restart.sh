#!/usr/bin/env bash
set -e

docker pull qpass/qpass-fe:latest
docker stop qpass
docker container rm qpass
docker run --name qpass --restart unless-stopped -dp 3000:80 qpass/qpass-fe:latest
