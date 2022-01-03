# Kong CICD tools selection Docker image

![Kong](https://github.com/svenwal/kong-cicd-tools/raw/main/kong-dark.png)

![CI](https://github.com/svenwal/kong-cicd-tools/raw/main/badge.svg)

When using the [Kong API Gateway](https://konghq.com/) (or its Enterprise version including the developer portal) automation of deployment and configuration is a key feature. As this is commonly done in a runner instance using Docker [I have prepared this image and made available on Docker Hub](https://hub.docker.com/r/svenwal/kong-cicd-tools) which has the typical tools preinstalled.

This image is getting updated on a monthly cadence, each release has a Docker tag so you can stay stable within your pipeline.

Starting with 2.0.0 this image is available for both AMD64 and ARM64.

## The following tools have been included

|Name|Description|Installed version|
|---|---|---|
|[decK](https://docs.konghq.com/deck/)|decK provides declarative configuration and drift detection for Kong.|1.10.0|
|[inso](https://support.insomnia.rest/collection/105-inso-cli)|Inso is a CLI (command line interface) for Insomnia Core and Insomnia Designer built on Node.js and the Insomnia core libraries. It allows you to use Insomnia application functionality in your terminal, and CI/CD environments. Providing you with powerful automation capabilities.|2.4.1|
|[portal cli](https://github.com/Kong/kong-portal-cli)|The Kong Developer Portal CLI is used to manage your Developer Portals from the command line|3.3.1|
|[httpie](https://httpie.io/)|HTTPie—aitch-tee-tee-pie—is a user-friendly command-line HTTP client for the API era. It comes with JSON support, syntax highlighting, persistent sessions, wget-like downloads, plugins, and more.|0.9.8|
|[yq](https://github.com/mikefarah/yq)|a lightweight and portable command-line YAML processor. Like jq but for YAML|4.16.2|
|[jq](https://stedolan.github.io/jq/)|jq is a lightweight and flexible command-line JSON processor.|1.5.1|
|[redis-tools](https://redis.io/topics/rediscli)|redis-cli is the Redis command line interface, a simple program that allows to send commands to Redis, and read the replies sent by the server, directly from the terminal.|5.0.14|
|[k6](https://k6.io/open-source)|AMD64 only! A modern load testing tool built for developer happiness|0.35.0|
|[Spectral](https://github.com/stoplightio/spectral)|Spectral, an Open Source JSON/YAML Linter|6.1.0|
|[kubeadm / kubectl](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)|The toolset to configure your Kubernetes|1.23.1|
|[Helm](https://helm.sh/)|The package manager for Kubernetes|3.7.0|
|[Kong portal template](https://github.com/Kong/kong-portal-templates)|Developer Portal Template Files for Kong Enterprise Edition|ef6a6c2|
|[PostgreSQL clients](https://www.postgresql.org/docs/11/reference-client.html)|PostgreSQL client applications and utilities (including pg_dump)|11.14|

## Any wishes?

If you are missing a tool on this image being used in your pipeline please add an issue at <https://github.com/svenwal/kong-cicd-tools/issues> and I will most probably add it to next (monthly) release.
