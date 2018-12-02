# Install
# docker_build_container . jstillery
#
# Build
# docker run -it s2e/jstillery bash

FROM node:8-jessie
MAINTAINER seamus tuohy <code@seamustuohy.com>

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    gnupg \
    rsync \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs

WORKDIR /var/www
ENV VERSION master
RUN git clone https://github.com/mindedsecurity/JStillery.git \
    && cd  JStillery \
    && git checkout $VERSION \
    && npm install \
    && npm run build_server

WORKDIR /var/www/JStillery
CMD ["npm", "run", "start_server"]