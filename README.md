# Kong CICD tools selection Docker image

![Kong](https://github.com/svenwal/kong-cicd-tools/raw/main/kong-dark.png)

![CI](https://github.com/svenwal/kong-cicd-tools/raw/main/badge.svg)

When using the [Kong API Gateway](https://konghq.com/) (or its Enterprise version including the developer portal) automation of deployment and configuration is a key feature. As this is commonly done in a runner instance using Docker [I have prepared this image and made available on Docker Hub](https://hub.docker.com/r/svenwal/kong-cicd-tools) which has the typical tools preinstalled.

This image is getting updated on a monthly cadence, each release has a Docker tag so you can stay stable within your pipeline.

Starting with 2.0.0 this image is available for both AMD64 and ARM64.

## The following tools have been included

|Name|Description|Installed version|
|---|---|---|
|[Kong Gateway](https://konghq.com/)|The Kong gateway this image is all about|3.8.0|
|[Kong Mesh](https://konghq.com/)|The Kong Mesh modern multi-zone service mesh (Enterprise version) - installed in /kong-mesh-latest/ |2.9.0|
|[Kuma](https://kuma.io/)|The Kuma modern multi-zone service mesh - installed in /kuma-latest/|2.9.0|
|[decK](https://docs.konghq.com/deck/)|decK provides declarative configuration and drift detection for Kong.|1.31.1|
|[inso](https://support.insomnia.rest/collection/105-inso-cli)|Inso is a CLI (command line interface) for Insomnia Core and Insomnia Designer built on Node.js and the Insomnia core libraries. It allows you to use Insomnia application functionality in your terminal, and CI/CD environments. Providing you with powerful automation capabilities. (AMD64 only so far)|10.1.1|
|[portal cli](https://github.com/Kong/kong-portal-cli)|The Kong Developer Portal CLI is used to manage your Developer Portals from the command line|3.6.3|
|[httpie](https://httpie.io/)|HTTPie—aitch-tee-tee-pie—is a user-friendly command-line HTTP client for the API era. It comes with JSON support, syntax highlighting, persistent sessions, wget-like downloads, plugins, and more.|3.2.1|
|[yq](https://github.com/mikefarah/yq)|a lightweight and portable command-line YAML processor. Like jq but for YAML|4.44.3|
|[jq](https://stedolan.github.io/jq/)|jq is a lightweight and flexible command-line JSON processor.|1.6|
|[openapi-format](https://github.com/thim81/openapi-format)|Format an OpenAPI document by ordering, formatting and filtering fields.|1.24.2|
|[AWS cli tools](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)|An open source tool that enables you to interact with AWS services using commands in your command-line shell.|2.19.0|
|[GCloud cli tools](https://cloud.google.com/sdk/docs)|The Google Cloud CLI is a set of tools that you can use to manage resources and applications hosted on Google Cloud.|499.0.0|
|[Azure cli tools](https://learn.microsoft.com/en-us/cli/azure/)|The Azure command-line interface (Azure CLI) is a set of commands used to create and manage Azure resources|2.65.0|
|[redis-tools](https://redis.io/topics/rediscli)|redis-cli is the Redis command line interface, a simple program that allows to send commands to Redis, and read the replies sent by the server, directly from the terminal.|7.0.15|
|[k6](https://k6.io/open-source)|A modern load testing tool built for developer happiness|0.54.0|
|[Spectral](https://github.com/stoplightio/spectral)|Spectral, an Open Source JSON/YAML Linter|6.5.0|
|[kubectl](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)|The toolset to configure your Kubernetes|1.31.2|
|[Helm](https://helm.sh/)|The package manager for Kubernetes|3.16.2|
|[PostgreSQL clients](https://www.postgresql.org/docs/11/reference-client.html)|PostgreSQL client applications and utilities (including pg_dump)|15.8|
|[Kong portal template](https://github.com/Kong/kong-portal-templates)|Developer Portal Template Files for Kong Enterprise Edition|496c80e|

## Any wishes?

If you are missing a tool on this image being used in your pipeline please add an issue at <https://github.com/svenwal/kong-cicd-tools/issues> and I will most probably add it to next (monthly) release.
