FROM node:15-buster

ARG TARGETPLATFORM
ARG DECK_VERSION=1.15.1
ARG YQ_VERSION=4.29.2
ARG HELM_VERSION=3.10.1
ARG K6_VERSION=0.41.0
ARG KONG_VERSION=3.0.0
ARG KUMA_VERSION=1.8.1
ARG KONG_MESH_VERSION=1.9.1

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
RUN VERSION=${KUMA_VERSION} curl -L https://kuma.io/installer.sh | bash -
RUN ln -s kuma-${KUMA_VERSION} kuma-latest
RUN VERSION=${KONG_MESH_VERSION} curl -L https://docs.konghq.com/mesh/installer.sh | bash -
RUN ln -s kong-mesh-${KONG_MESH_VERSION} kong-mesh-latest

# anything else
RUN apt-get update
RUN apt-get -y install apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get -y install jq
RUN apt-get -y install httpie
RUN apt-get -y install redis-tools
RUN apt-get -y install postgresql-client
RUN apt-get install -y kubelet kubeadm kubectl
RUN npm install -g kong-portal-cli
RUN npm install -g @stoplight/spectral
RUN mkdir /opt/work
RUN cd /opt/work && git clone https://github.com/Kong/kong-portal-templates.git

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]