#!/bin/sh
if [ $# -lt "1" ]
then
  echo "USAGE publish_to_docker_hub.sh TAG"
  echo ""
  exit
fi  

tag=$1

echo "*** Publishing current state to Docker Hub with the tags $tag and latest"
echo "--- 1. Building current version $tag"
docker buildx build --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag .
docker buildx build --build-arg INCLUDE_CLOUD_CLIS=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-cloud-clis .
docker buildx build --build-arg INCLUDE_CLOUD_CLIS=false --build-arg INCLUDE_MESH=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-cloud-clis-no-mesh .
docker buildx build --build-arg INCLUDE_CLOUD_CLIS=false --build-arg INCLUDE_MESH=false --build-arg INCLUDE_GATEWAY=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-cloud-clis-no-mesh-no-gateway .
docker buildx build --build-arg INCLUDE_MESH=false --build-arg INCLUDE_GATEWAY=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-mesh-no-gateway .
docker buildx build --build-arg INCLUDE_MESH=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-mesh .
docker buildx build --build-arg INCLUDE_GATEWAY=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-gateway .

echo "--- 2. Building current version as latest"
tag="latest"
docker buildx build --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag .
docker buildx build --build-arg INCLUDE_CLOUD_CLIS=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-cloud-clis .
docker buildx build --build-arg INCLUDE_CLOUD_CLIS=false --build-arg INCLUDE_MESH=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-cloud-clis-no-mesh .
docker buildx build --build-arg INCLUDE_CLOUD_CLIS=false --build-arg INCLUDE_MESH=false --build-arg INCLUDE_GATEWAY=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-cloud-clis-no-mesh-no-gateway .
docker buildx build --build-arg INCLUDE_MESH=false --build-arg INCLUDE_GATEWAY=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-mesh-no-gateway .
docker buildx build --build-arg INCLUDE_MESH=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-mesh .
docker buildx build --build-arg INCLUDE_GATEWAY=false --push --platform linux/amd64,linux/arm64 -t svenwal/kong-cicd-tools:$tag-no-gateway .


