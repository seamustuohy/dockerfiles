#
# This file is part of Viper - https://github.com/viper-framework/viper
# See the file 'LICENSE' for copying permission.
#

#FROM ubuntu:rolling
FROM debian:buster
MAINTAINER Seamus Tuohy  code@seamustuohy.com

ENV LANG C.UTF-8
ENV YARA_VERSION       3.4.0
ENV SSDEEP_VERSION     2.13
ENV PYEXIF_VERSION     0.2.0
ENV ANDROGUARD_VERSION 1.9
ENV VIPER_VERSION      1.3

USER root
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    python3-dev \
    python3-pip \
    libssl-dev \
    swig \
    libffi-dev \
    ssdeep \
    libfuzzy-dev \
    libdpkg-perl \
    python3-socks \
    exiftool \
    make \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*


# Will force rebuild from this point based on the date
# See installer for info
ARG GIT_CACHE_DATE="2021-01-01"

# APKTOOL See:Docker image s2e/apktool
# https://github.com/yongjhih/docker-apktool

# DEX2JAR
# https://github.com/yongjhih/docker-dex2jar

# JADX
# https://github.com/samsheff/docker-jadx

ENV LANG C.UTF-8

# Create Unprivlaged User
RUN groupadd -r user && \
  useradd -r -g user -d /home/user -s /sbin/nologin -c "User" user && \
  mkdir /home/user && \
  chown -R user:user /home/user

USER root
WORKDIR /home/user
CMD ["bash"]
