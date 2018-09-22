FROM debian:buster
MAINTAINER Seamus Tuohy (code@seamustuohy.com)

USER root
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    wget \
    curl \
    zip \
    whois \
    urlview \
    urlscan \
    unzip \
    zip \
    tree \
    tor \
    torsocks \
    exiftool \
    strace \
    lynx \
    poppler-utils \
    vim \
    python3-dev \
    python3-pip \
    libssl-dev \
    python3-socks \
    make \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create Unprivlaged User
RUN groupadd -r user && \
  useradd -r -g user -d /home/user -s /sbin/nologin -c "User" user && \
  mkdir /home/user && \
  chown -R user:user /home/user

USER root
WORKDIR /home/user
CMD ["bash"]
