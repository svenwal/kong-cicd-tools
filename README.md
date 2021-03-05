# Kong CICD tools selection Docker image

![Kong](kong-dark.png)

![CI](badge.svg)

When using the [Kong API Gateway](https://konghq.com/) (or its Enterprise version including the developer portal) automation of deployment and configuration is a key feature. As this is commonly done in a runner instance using Docker [I have prepared this image and made available on Docker Hub](https://hub.docker.com/r/svenwal/kong-cicd-tools) which has the typical tools preinstalled.

## The following tools have been included

|Name|Description|Installed version|
|---|---|---|
|[decK](https://docs.konghq.com/deck/)|decK provides declarative configuration and drift detection for Kong.|1.4.0|
|[inso](https://support.insomnia.rest/collection/105-inso-cli)|Inso is a CLI (command line interface) for Insomnia Core and Insomnia Designer built on Node.js and the Insomnia core libraries. It allows you to use Insomnia application functionality in your terminal, and CI/CD environments. Providing you with powerful automation capabilities.|2.2.30|
|[portal cli](https://github.com/Kong/kong-portal-cli)|The Kong Developer Portal CLI is used to manage your Developer Portals from the command line|3.1.0|
|[httpie](https://httpie.io/)|HTTPie—aitch-tee-tee-pie—is a user-friendly command-line HTTP client for the API era. It comes with JSON support, syntax highlighting, persistent sessions, wget-like downloads, plugins, and more.|0.9.8|
|[yq](https://github.com/mikefarah/yq)|a lightweight and portable command-line YAML processor. Like jq but for YAML|4.6.1|
|[jq](https://stedolan.github.io/jq/)|jq is a lightweight and flexible command-line JSON processor.|1.5.1|
|[k6](https://k6.io/open-source)|A modern load testing tool built for developer happiness|0.30.0|
|[Spectral](https://github.com/stoplightio/spectral)|Spectral, an Open Source JSON/YAML Linter|5.8.1|
|[Kong portal template](https://github.com/Kong/kong-portal-templates)|Developer Portal Template Files for Kong Enterprise Edition|cec65e5|
