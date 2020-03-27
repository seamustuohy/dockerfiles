FROM debian:buster
MAINTAINER Seamus Tuohy (code@seamustuohy.com)

USER root
RUN apt-get update && apt-get install -y \
    git \
    ruby \
    ruby-dev \
    build-essential \
    make \
    sudo \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*


# usermod --shell /bin/bash

# Create Unprivlaged User
RUN groupadd -r user && \
  useradd -r -g user -d /home/user -s /sbin/nologin -c "User" user && \
  usermod -a -G sudo user && \
  usermod --shell /bin/bash user && \
  mkdir /home/user && \
  chown -R user:user /home/user

RUN gem install jekyll bundler

RUN apt-get update && apt-get install -y \
    less \
    zlib1g-dev \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*



USER root
WORKDIR /home/user
# RUN PASSWORD FIRST
# passwd user && su user
CMD ["bash"]
