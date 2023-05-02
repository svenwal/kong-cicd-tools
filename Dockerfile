FROM node:15-buster

ARG TARGETPLATFORM
ARG KONG_VERSION=3.2.2
ARG KUMA_VERSION=2.2.0
ARG KONG_MESH_VERSION=2.2.0
ARG DECK_VERSION=1.19.1
ARG YQ_VERSION=4.33.3
ARG HELM_VERSION=3.11.3
ARG K6_VERSION=0.44.0

LABEL maintainer="sven@svenwal.de"
LABEL org.label-schema.description="When using the Kong API Gateway (or its Enterprise version including the developer portal) automation of deployment and configuration is a key feature. As this is commonly done in a runner instance using Docker I have prepared this image and made available on Docker Hub which has the typical tools preinstalled."
LABEL org.label-schema.name="Kong CI/CD tools"
LABEL org.label-schema.vendor = "SvenWal"
LABEL org.label-schema.url="https://github.com/svenwal/kong-cicd-tools"
RUN npm install --global insomnia-inso
# Deck
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -sL https://github.com/kong/deck/releases/download/v${DECK_VERSION}/deck_${DECK_VERSION}_linux_amd64.tar.gz -o deck.tar.gz; else curl -sL https://github.com/kong/deck/releases/download/v${DECK_VERSION}/deck_${DECK_VERSION}_linux_arm64.tar.gz -o deck.tar.gz; fi
RUN tar -xf deck.tar.gz -C /tmp
RUN cp /tmp/deck /usr/local/bin/
## yq
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq ; else wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_arm64 -O /usr/bin/yq && chmod +x /usr/bin/yq; fi
# Helm
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tgz; else curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-arm64.tar.gz -o helm.tgz; fi
RUN tar -zxvf helm.tgz
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then mv linux-amd64/helm /usr/bin; else mv linux-arm64/helm /usr/bin; fi
RUN rm helm.tgz
# k6
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then wget https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-amd64.tar.gz -O k6.tgz && tar -zxvf k6.tgz && mv k6-v${K6_VERSION}-linux-amd64/k6 /usr/bin ; else wget https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-arm64.tar.gz -O k6.tgz && tar -zxvf k6.tgz && mv k6-v${K6_VERSION}-linux-arm64/k6 /usr/bin ; fi
RUN chmod +x /usr/bin/k6 && rm k6.tgz
# Kong gateway
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -Lo kong.deb "https://download.konghq.com/gateway-3.x-debian-buster/pool/all/k/kong/kong_${KONG_VERSION}_amd64.deb" && dpkg -i kong.deb && rm kong.deb; fi
# Kuma / Kong Mesh
RUN curl -L https://kuma.io/installer.sh | VERSION=${KUMA_VERSION} bash -
RUN ln -s kuma-${KUMA_VERSION} kuma-latest
RUN curl -L https://docs.konghq.com/mesh/installer.sh | VERSION=${KONG_MESH_VERSION} bash -
RUN ln -s kong-mesh-${KONG_MESH_VERSION} kong-mesh-latest

# anything else
RUN apt-get update
RUN apt-get -y install apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# cloud tools
# AWS
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o "awscliv2.zip"; else curl -sL https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o "awscliv2.zip"; fi
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm awscliv2.zip
RUN rm -rf aws

# Google Cloud
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then curl -sL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-424.0.0-linux-x86_64.tar.gz -o "gcloud.tar.gz"; else curl -sL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-424.0.0-linux-arm.tar.gz -o "gcloud.tar.gz"; fi
RUN tar -xf gcloud.tar.gz
RUN CLOUDSDK_CORE_DISABLE_PROMPTS=1 ./google-cloud-sdk/install.sh
RUN echo ". /google-cloud-sdk/path.bash.inc" >> ~/.bashrc
RUN rm gcloud.tar.gz

RUN mkdir -p /etc/apt/keyrings
RUN curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null
RUN chmod go+r /etc/apt/keyrings/microsoft.gpg
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ buster main" | tee /etc/apt/sources.list.d/azure-cli.list; else echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ buster main" | tee /etc/apt/sources.list.d/azure-cli.list; fi
RUN apt-get update
RUN apt-get -y install azure-cli

RUN apt-get -y install jq
RUN apt-get -y install httpie
RUN apt-get -y install redis-tools
RUN apt-get -y install postgresql-client
RUN apt-get install -y kubelet kubeadm kubectl
RUN npm install -g kong-portal-cli
RUN npm install -g @stoplight/spectral
RUN npm install -g openapi-format
RUN mkdir /opt/work
RUN cd /opt/work && git clone https://github.com/Kong/kong-portal-templates.git

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]