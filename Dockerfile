FROM node:latest
RUN npm i -g insomnia-inso
RUN curl -sL https://github.com/kong/deck/releases/download/v1.4.0/deck_1.4.0_linux_amd64.tar.gz -o deck.tar.gz
RUN tar -xf deck.tar.gz -C /tmp
RUN cp /tmp/deck /usr/local/bin/
RUN wget https://github.com/mikefarah/yq/releases/download/v4.6.1/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
RUN apt-get update
RUN apt-get -y install apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
RUN echo "deb https://dl.bintray.com/loadimpact/deb stable main" | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install jq
RUN apt-get -y install httpie
RUN apt-get -y install k6
RUN npm install -g kong-portal-cli
RUN npm install -g @stoplight/spectral
RUN mkdir /opt/work
RUN cd /opt/work && git clone https://github.com/Kong/kong-portal-templates.git
