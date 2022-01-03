#!/bin/sh
if [ $# -lt "1" ]
then
  echo "USAGE publish_to_docker_hub.sh TAG"
  echo ""
  exit
fi  

tag=$1

echo "*** Publishing current state to Docker Hub with the tags $tag and latest"
echo "--- 1. Building current version $tag without using caches"
docker buildx build --push --platform linux/amd64,linux/arm64 --no-cache -t svenwal/kong-cicd-tools:$tag .
echo "--- 2. Building current version as latest"
docker buildx build --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:latest .

