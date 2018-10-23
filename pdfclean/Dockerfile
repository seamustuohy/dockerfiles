## pdf-redact-tools and other tools for redacting PDF's

FROM debian:buster
MAINTAINER Seamus Tuohy <code@seamustuohy.com>

# ENV PYEXIF_VERSION     0.2.0
ENV NON_PRIV_USER     pdfredactor

USER root
RUN apt-get update && apt-get install -y \
    git \
    sudo \
    exiftool \
    qpdf \
    imagemagick \
    libimage-exiftool-perl \
    python-stdeb \
    python-all \
    dh-python \
    fakeroot build-essential \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create User
RUN groupadd -r "${NON_PRIV_USER}" && \
  useradd -r -g "${NON_PRIV_USER}" -d /home/"${NON_PRIV_USER}" -s /sbin/nologin -c "${NON_PRIV_USER} User" "${NON_PRIV_USER}" && \
  mkdir /home/"${NON_PRIV_USER}" && \
  chown -R "${NON_PRIV_USER}:${NON_PRIV_USER}" "/home/${NON_PRIV_USER}"

# Add to sudoers
RUN echo "${NON_PRIV_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER "${NON_PRIV_USER}"
WORKDIR /home/${NON_PRIV_USER}
RUN git clone https://github.com/micahflee/pdf-redact-tools.git \
    && cd pdf-redact-tools \
    && ./build_deb.sh \
    && sudo dpkg -i deb_dist/pdf-redact-tools_*-1_all.deb

# Set Local
# Errors out on errors like the following without this
# UnicodeEncodeError: 'ascii' codec can't encode character '\u5411' in position 940: ordinal not in range(128)
# RUN apt-get clean && apt-get update && apt-get install -y locales
# RUN locale-gen en_US.UTF-8
# ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
# ENV PYTHONIOENCODING='utf-8'
ENV LANG C.UTF-8

WORKDIR /home/root/
CMD ["bash"]
