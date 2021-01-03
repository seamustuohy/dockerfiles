FROM debian:buster
MAINTAINER Seamus Tuohy (code@seamustuohy.com)

ENV LANG C.UTF-8

USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    less \
    python3-dev \
    python3-pip \
    python3-setuptools \
    libicu-dev \
    pkg-config \
    tor \
    torsocks \
    python3-socks \
    locales \
    locales-all \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# ENV ICU_VERSION $(icuinfo |grep '<param name="version">' | cut -d '>' -f 2 | cut -d '<' -f 1)

RUN pip3 install \
    setuptools \
    wheel

RUN pip3 install \
    PyICU \
    pycld2 \
    six \
    futures \
    morfessor \
    numpy \
    polyglot \
    google-cloud-translate \
    feedparser

# Create Unprivlaged User
RUN groupadd -r user --gid 1000 && \
  useradd -r -g user -d /home/user -s /sbin/nologin -c "User" user --uid 1000 && \
  mkdir /home/user && \
  chown -R user:user /home/user

RUN mkdir /DB  && chown user /DB
RUN mkdir /var/RSS && chown user /var/RSS

USER user
WORKDIR /home/user

ENV GOOGLE_APPLICATION_CREDENTIALS /var/GT/google_translate.json

# COPY google_translate.py /usr/local/bin/google_translate.py
COPY rss_translate.py /usr/local/bin/rss_translate.py

# CMD ["bash"]
ENTRYPOINT ["python3", "/usr/local/bin/rss_translate.py"]
