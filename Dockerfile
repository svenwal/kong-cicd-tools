FROM node:latest
RUN npm i -g insomnia-inso
RUN curl -sL https://github.com/kong/deck/releases/download/v1.2.1/deck_1.2.1_linux_amd64.tar.gz -o deck.tar.gz
RUN tar -xf deck.tar.gz -C /tmp
RUN cp /tmp/deck /usr/local/bin/
RUN wget https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
RUN apt-get update
RUN apt-get -y install jq
