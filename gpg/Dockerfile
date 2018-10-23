FROM debian:buster
MAINTAINER Seamus Tuohy (code@seamustuohy.com)
#

USER root
RUN apt-get update && apt-get install -y \
    git \
    gnupg2 \
    gnupg-agent \
    pinentry-curses \
    scdaemon \
    pcscd \
    yubikey-personalization \
    libusb-1.0-0-dev \
    less \
    qrencode \
    cryptsetup \
    vim \
    make \
    usbutils \
    procps \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create Unprivlaged User
RUN groupadd -r user && \
  useradd -r -g user -d /home/user -s /sbin/nologin -c "User" user && \
  mkdir /home/user && \
  mkdir /home/user/.gnupg && \
  chown -R user:user /home/user && \
  chmod 700 /home/user/.gnupg

COPY entrypoint.sh /usr/local/bin/
COPY make_keys.sh /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

WORKDIR /root
# USER user
# WORKDIR /home/user
CMD ["bash"]
