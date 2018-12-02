#
# This file is part of Viper - https://github.com/viper-framework/viper
# See the file 'LICENSE' for copying permission.
#

FROM ubuntu:rolling
MAINTAINER seamus tuohy (code@seamustuohy.com)

USER root
RUN apt-get update && \
    apt-get install -y \
    android-sdk \
    cmake \
    git \
    gcc \
    make \
    curl \
    unzip \
    ca-certificates \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 5037

CMD ["bash"]
