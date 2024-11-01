FROM node:21-bookworm-slim

ARG INCLUDE_CLOUD_CLIS=true
ARG INCLUDE_MESH=true
ARG INCLUDE_GATEWAY=true

ARG TARGETPLATFORM
ARG KONG_VERSION=3.8.0
ARG KONG_FOLDER=38
ARG KUMA_VERSION=2.9.0
ARG KONG_MESH_VERSION=2.9.0
ARG DECK_VERSION=1.41.1
ARG INSO_VERSION=10.1.1
ARG YQ_VERSION=4.44.3
ARG HELM_VERSION=3.16.2
ARG K6_VERSION=0.54.0

LABEL maintainer="sven@svenwal.de"
LABEL org.label-schema.description="When using the Kong API Gateway (or its Enterprise version including the developer portal) automation of deployment and configuration is a key feature. As this is commonly done in a runner instance using Docker I have prepared this image and made available on Docker Hub which has the typical tools preinstalled."
LABEL org.label-schema.name="Kong CI/CD tools"
LABEL org.label-schema.vendor="SvenWal"
LABEL org.label-schema.url="https://github.com/svenwal/kong-cicd-tools"

RUN apt-get update && apt-get install curl wget gnupg unzip python3 libcurl4-openssl-dev libssl-dev git libpcre3 zlib1g-dev libyaml-0-2 xz-utils -y
# Deck
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; \
then curl -sL https://github.com/kong/deck/releases/download/v${DECK_VERSION}/deck_${DECK_VERSION}_linux_amd64.tar.gz -o deck.tar.gz && \
tar -xf deck.tar.gz -C /tmp && \
cp /tmp/deck /usr/local/bin/ && \
rm deck.tar.gz; else curl -sL https://github.com/kong/deck/releases/download/v${DECK_VERSION}/deck_${DECK_VERSION}_linux_arm64.tar.gz -o deck.tar.gz && \
tar -xf deck.tar.gz -C /tmp && \
cp /tmp/deck /usr/local/bin/ && \
rm deck.tar.gz; fi
## yq
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq ; else wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_arm64 -O /usr/bin/yq && chmod +x /usr/bin/yq; fi
# Helm
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tgz && \
tar -zxf helm.tgz && \
mv linux-amd64/helm /usr/bin && \
rm helm.tgz; else curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-arm64.tar.gz -o helm.tgz && \
tar -zxf helm.tgz && \
mv linux-arm64/helm /usr/bin && \
rm helm.tgz; fi
# k6
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then wget https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-amd64.tar.gz -O k6.tgz && tar -zxf k6.tgz && mv k6-v${K6_VERSION}-linux-amd64/k6 /usr/bin && chmod +x /usr/bin/k6 && rm k6.tgz ; else wget https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-arm64.tar.gz -O k6.tgz && tar -zxf k6.tgz && mv k6-v${K6_VERSION}-linux-arm64/k6 /usr/bin && chmod +x /usr/bin/k6 && rm k6.tgz ; fi
# Kong gateway
RUN if [ "$INCLUDE_GATEWAY" = "true" ]; \
    then \
        if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
            curl -Lo kong.deb "https://packages.konghq.com/public/gateway-${KONG_FOLDER}/deb/ubuntu/pool/jammy/main/k/ko/kong_${KONG_VERSION}/kong_${KONG_VERSION}_amd64.deb"; \
        else \
            curl -Lo kong.deb "https://packages.konghq.com/public/gateway-${KONG_FOLDER}/deb/ubuntu/pool/jammy/main/k/ko/kong_${KONG_VERSION}/kong_${KONG_VERSION}_arm64.deb"; \
        fi; \
        dpkg -i kong.deb && rm kong.deb; \
    fi
# Kuma / Kong Mesh
RUN if [ "$INCLUDE_MESH" = "true" ]; then curl -L https://kuma.io/installer.sh | VERSION=${KUMA_VERSION} bash - && ln -s kuma-${KUMA_VERSION} kuma-latest && curl -L https://docs.konghq.com/mesh/installer.sh | VERSION=${KONG_MESH_VERSION} bash - && ln -s kong-mesh-${KONG_MESH_VERSION} kong-mesh-latest; fi

# anything else
RUN apt-get update && apt-get -y install apt-transport-https ca-certificates && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; else curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"; fi && chmod +x kubectl && mv kubectl /usr/local/bin
# cloud tools
# AWS
RUN if [ "$INCLUDE_CLOUD_CLIS" = "true" ]; then if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o "awscliv2.zip" && \
unzip awscliv2.zip && \
./aws/install && \
rm awscliv2.zip && \
rm -rf aws; else curl -sL https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o "awscliv2.zip" && \
unzip awscliv2.zip && \
./aws/install && \
rm awscliv2.zip && \
rm -rf aws; fi;fi

# Google
RUN if [ "$INCLUDE_CLOUD_CLIS" = "true" ]; then curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && apt-get update && apt-get install google-cloud-cli -y; fi

RUN if [ "$INCLUDE_CLOUD_CLIS" = "true" ]; then curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && chmod go+r /etc/apt/keyrings/microsoft.gpg && if [ "$TARGETPLATFORM" = "linux/amd64" ]; then echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ bookworm main" | tee /etc/apt/sources.list.d/azure-cli.list; else echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ bookworm main" | tee /etc/apt/sources.list.d/azure-cli.list; fi; apt-get update && apt-get install azure-cli; fi

# inso cli
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -Lo inso.tar.xz "https://github.com/Kong/insomnia/releases/download/core%40${INSO_VERSION}/inso-linux-${INSO_VERSION}.tar.xz" && \
unxz inso.tar.xz && \
tar -xf inso.tar && \
mv inso /usr/bin && \
rm inso.tar; fi;

RUN apt-get update && apt-get -y install  jq httpie redis-tools postgresql-client dnsutils

RUN npm install -g kong-portal-cli @stoplight/spectral openapi-format
RUN mkdir /opt/work
RUN cd /opt/work && git clone https://github.com/Kong/kong-portal-templates.git

COPY entrypoint.sh /entrypoint.sh
COPY listInstalledVersions.sh /listInstalledVersions.sh
CMD ["/entrypoint.sh"]
