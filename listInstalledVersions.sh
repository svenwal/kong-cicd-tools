#!/bin/sh
echo "*** Kong"
kong version

echo "*** Kuma"
/kuma-latest/bin/kumactl version

echo "*** Kong Mesh"
/kong-mesh-latest/bin/kumactl version

echo "*** decK"
deck version

echo "*** inso cli"
inso --version

echo "*** portal cli"
portal --version

echo "*** httpie"
http --version

echo "*** yq"
yq --version

echo "*** jq"
jq --version

echo "*** openapi-format"
openapi-format --version

echo "*** AWS"
aws --version

echo "*** GCloud"
gcloud --version

echo "*** Azure CLI"
az --version

echo "*** Redis CLI"
redis-cli --version

echo "*** k6"
k6 --version

echo "*** spectral"
spectral --version

echo "*** kubectl"
kubectl version

echo "*** helm"
helm version

echo "*** psql"
psql --version

echo "*** portal template"
echo "see https://github.com/Kong/kong-portal-templates"
