#!/bin/sh
if [ $# -lt "1" ]
then
  echo "USAGE publish_to_docker_hub.sh TAG"
  echo ""
  exit
fi  

tag=$1

echo "*** Publishing current state to Docker Hub with the tags $tag and latest"
echo "--- 1. Building current version without using caches"
docker build --no-cache -t svenwal/kong-cicd-tools:$tag .
docker build -t svenwal/kong-cicd-tools:latest .

echo "--- 2. Pushing to Docker hub"
docker push svenwal/kong-cicd-tools:$tag
docker push svenwal/kong-cicd-tools:latest
