FROM debian:buster
MAINTAINER Seamus Tuohy

ENV LANG C.UTF-8

        # sudo apt-get update
        # sudo apt-get -y p7zip-full p7zip-rar libxml2-dev libxslt1-dev
        # pip install -r dev-requirements.txt
        # pip install lxml exifread pillow olefile oletools
        # pip install git+https://github.com/grierforensics/officedissector.git
        # wget https://didierstevens.com/files/software/pdfid_v0_2_1.zip
        # unzip pdfid_v0_2_1.zip

USER root
# Create circlean
RUN groupadd -r circlean && \
  useradd -r -g circlean -d /home/circlean -s /sbin/nologin -c "circlean User" circlean && \
  mkdir /home/circlean && \
  chown -R circlean:circlean /home/circlean

# Installation
RUN apt-get update && apt-get install -y \
    git \
    python3-dev \
    python3-pip \
    wget \
    unzip \
    make \
    libmagic-dev \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN  pip3 install \
     setuptools \
     wheel \
     --upgrade

RUN pip3 install \
    lxml \
    exifread \
    pillow \
    olefile \
    oletools \
    --upgrade

RUN pip3 install git+https://github.com/grierforensics/officedissector.git

# Will force rebuild from this point based on the date
# See installer for info
ARG GIT_CACHE_DATE="2018-06-17-19"

RUN pip3 install git+https://github.com/seamustuohy/pdfid_clone.git

# # PDFID
# WORKDIR /tmp/
# ENV PDFID_VERSION 0_2_4
# RUN wget "http://didierstevens.com/files/software/pdfid_v${PDFID_VERSION}.zip" \
#     && unzip pdfid_v${PDFID_VERSION}.zip

WORKDIR /home/circlean
RUN git clone https://github.com/CIRCL/PyCIRCLean.git \
    && cd PyCIRCLean \
    && python3 setup.py install

USER circlean
WORKDIR /home/circlean
CMD ["bash"]
