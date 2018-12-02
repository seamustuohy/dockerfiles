# Install
# docker_build_container . cyberchef
#
# Build
# docker run -it s2e/cyberchef bash

FROM node:8-jessie
MAINTAINER seamus tuohy <code@seamustuohy.com>

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    gnupg \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*


RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g grunt-cli

WORKDIR /var/www
ENV VERSION v8.12.3
RUN git clone https://github.com/gchq/CyberChef.git \
    && cd CyberChef \
    && git checkout $VERSION \
    && npm install

WORKDIR /var/www/CyberChef
CMD ["grunt", "dev"]