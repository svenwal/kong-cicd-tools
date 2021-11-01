FROM node:15-buster
LABEL maintainer="sven@svenwal.de"
LABEL org.label-schema.description="When using the Kong API Gateway (or its Enterprise version including the developer portal) automation of deployment and configuration is a key feature. As this is commonly done in a runner instance using Docker I have prepared this image and made available on Docker Hub which has the typical tools preinstalled."
LABEL org.label-schema.name="Kong CI/CD tools"
LABEL org.label-schema.vendor = "SvenWal"
LABEL org.label-schema.url="https://github.com/svenwal/kong-cicd-tools"
RUN wget https://github.com/Kong/insomnia/releases/download/lib%402.4.0/inso-linux-2.4.0.tar.xz
RUN tar -xf inso-linux-2.4.0.tar.xz
RUN mv inso /bin/inso
RUN curl -sL https://github.com/kong/deck/releases/download/v1.8.2/deck_1.8.2_linux_amd64.tar.gz -o deck.tar.gz
RUN tar -xf deck.tar.gz -C /tmp
RUN cp /tmp/deck /usr/local/bin/
RUN wget https://github.com/mikefarah/yq/releases/download/v4.14.1/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
RUN wget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz
RUN tar -zxvf helm-v3.7.1-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/bin
RUN apt-get update
RUN apt-get -y install apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
RUN echo "deb https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get -y install jq
RUN apt-get -y install httpie
RUN apt-get -y install k6
RUN apt-get -y install redis-tools
RUN apt-get -y install postgresql-client
RUN apt-get install -y kubelet kubeadm kubectl
RUN npm install -g kong-portal-cli
RUN npm install -g @stoplight/spectral
RUN mkdir /opt/work
RUN cd /opt/work && git clone https://github.com/Kong/kong-portal-templates.git
