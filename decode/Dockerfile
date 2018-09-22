
FROM debian:buster
MAINTAINER seamus tuohy <code@seamustuohy.com>

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y python3 \
                               python3-dev \
                               python3-pip \
                               git \
                               sudo \
                               build-essential \
                               --no-install-recommends \
                               && rm -rf /var/lib/apt/lists/*

# RUN pip3 install setuptools wheel --upgrade

# Will force rebuild from this point based on the date
# See installer for info
ARG GIT_CACHE_DATE="2018-04-10"

RUN git clone https://github.com/seamustuohy/Decodify \
    && cd Decodify \
    && make install
RUN echo 'alias python="python3"' >> ~/.bashrc

# run the application
CMD [ "dcode" ]