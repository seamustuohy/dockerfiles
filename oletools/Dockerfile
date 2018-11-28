# Install
# docker_build_container . oletool
#
# Build
# docker run -it -v ~/malware:/root/malware s2e/oletool bash

FROM debian:buster
MAINTAINER seamus tuohy <code@seamustuohy.com>

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    git \
    gcc \
    vim \
    python \
    python-pip \
    python-dev \
    make \
    unzip \
    wget \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN pip install setuptools wheel --upgrade
RUN pip install olefile oletools

WORKDIR /repos/
RUN wget https://didierstevens.com/files/software/DidierStevensSuite.zip \
    && unzip DidierStevensSuite.zip

WORKDIR /code/oledump/
RUN cp "/repos/DidierStevensSuite/oledump.py" . \
    && cp "/repos/DidierStevensSuite/maldoc.yara" . \
    && cp "/repos/DidierStevensSuite/vba.yara" . \
    && cp "/repos/DidierStevensSuite/contains_pe_file.yara" . \
    && cp /repos/DidierStevensSuite/decoder_* . \
    && cp /repos/DidierStevensSuite/plugin_* .

WORKDIR /code/office/
RUN cp "/repos/DidierStevensSuite/zipdump.py" . \
    && cp "/repos/DidierStevensSuite/re-search.py" . \
    && cp "/repos/DidierStevensSuite/base64dump.py" . \
    && cp "/repos/DidierStevensSuite/cipher-tool.py" . \
    && cp "/repos/DidierStevensSuite/find-file-in-file.py" . \
    && cp "/repos/DidierStevensSuite/xmldump.py" . \
    && cp "/repos/DidierStevensSuite/emldump.py" .

WORKDIR /code/images/
RUN cp "/repos/DidierStevensSuite/image-forensics-ela.py" . \
    && cp "/repos/DidierStevensSuite/image-overlay.py" . \
    && cp "/repos/DidierStevensSuite/jpegdump.py" . \
    && cp "/repos/DidierStevensSuite/JPEG_EXIF_Contains_eval.yara" .

WORKDIR /code/rtf/
RUN cp "/repos/DidierStevensSuite/rtf.yara" . \
    && cp "/repos/DidierStevensSuite/rtfdump.py" .


WORKDIR /code/decoding/
RUN cp "/repos/DidierStevensSuite/js-unicode-escape.1sc" . \
    && cp "/repos/DidierStevensSuite/js-unicode-unescape.1sc" .


WORKDIR /code/pdf/
RUN cp "/repos/DidierStevensSuite/pdf-parser.py" . \
    && cp "/repos/DidierStevensSuite/pdfid.py" .


# https://blog.didierstevens.com/programs/oledump-py/
# RUN git clone https://github.com/seamustuohy/oledump.git \
#     && git clone
# python2 oledump/oledump.py -s 3 malware/email.msg
# python2 oledump/oledump.py --pluginoptions=-k -p oledump/plugin_msg.py  malware/email.msg

COPY .bashrc /root/.bashrc
WORKDIR /root/
CMD ["bash"]