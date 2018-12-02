# Creates an OONI-Run URL using a line  seperated file of URL's
# URL's should be full URL's http[s]+://host.domain.tld/etc

FROM debian:buster
MAINTAINER Seamus Tuohy (code@seamustuohy.com)

USER root
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    git \
    curl \
    gnupg \
    ca-certificates \
    nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root/

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install yarn \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ooni/run.git \
    && cd run/ \
    && yarn install

WORKDIR /root/run/
CMD ["yarn", "run", "genurl", "--", "/tmp/local_urls.lsv"]
