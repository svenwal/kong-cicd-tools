FROM node:latest
RUN npm i -g insomnia-inso
RUN curl -sL https://github.com/kong/deck/releases/download/v1.2.1/deck_1.2.1_linux_amd64.tar.gz -o deck.tar.gz
RUN tar -xf deck.tar.gz -C /tmp
RUN cp /tmp/deck /usr/local/bin/
