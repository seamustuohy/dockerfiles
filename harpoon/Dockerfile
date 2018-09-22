
FROM debian:buster
MAINTAINER seamus tuohy <code@seamustuohy.com>

RUN apt-get update && apt-get install -y python3 \
                               python3-dev \
                               python3-pip \
                               git \
                               build-essential \
                               vim \
                               --no-install-recommends \
                               && rm -rf /var/lib/apt/lists/*

RUN pip3 install setuptools wheel --upgrade

# Will force rebuild from this point based on the date
# See installer for info
ARG GIT_CACHE_DATE="2018-04-10"

RUN git clone https://github.com/Te-k/harpoon.git \
    && cd harpoon \
    && pip3 install -r requirements.txt \
    && python3 setup.py install

# For MISP integration
RUN pip3 install pymisp

# Local tools for exploring issues
RUN apt-get update && apt-get install -y \
                               less \
                               curl \
                               wget \
                               --no-install-recommends \
                               && rm -rf /var/lib/apt/lists/*

# Make a user
ENV HOME /home/harpoon
RUN useradd --create-home --home-dir $HOME harpoon \
        && chown -R harpoon:harpoon $HOME

WORKDIR $HOME
USER harpoon

# run the application
CMD [ "/bin/bash" ]