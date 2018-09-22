FROM alpine:3.4

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
    libffi-dev \
    openssl-dev \
    openssh \
    linux-headers \
    git

RUN pip install ansible markupsafe

RUN pip install boto dopy==0.3.5 "apache-libcloud>=0.17.0" linode-python pyrax

RUN git clone https://github.com/StreisandEffect/streisand

VOLUME /root/.ssh
VOLUME /streisand/generated-docs

WORKDIR /streisand
RUN apk add --update bash
CMD ["/bin/bash", "/streisand/streisand"]
