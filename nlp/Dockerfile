FROM debian:buster
MAINTAINER Seamus Tuohy

ENV NLTK_DATA_DIR /usr/lib/nltk_data

USER root
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-dev \
    python3-pip \
    python-numpy \
    poppler-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8

RUN  pip3 install \
     setuptools \
     wheel \
     --upgrade

RUN apt-get update && apt-get install -y \
    build-essential \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN  pip3 install \
     python-magic \
     numpy \
     sumy \
     scrapy \
     beautifulsoup4 \
     polyglot \
     newspaper3k \
     ahocorasick \
     --upgrade

# Install Geography
# https://github.com/ushahidi/geograpy/issues/21
RUN python3 -m pip install git+https://github.com/reach2ashish/geograpy.git

# === Install Nltk Libraries ===
RUN mkdir -p "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader words -d "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader treebank -d "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader maxent_treebank_pos_tagger -d "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader maxent_ne_chunker -d "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader punkt -d "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader stopwords -d "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader averaged_perceptron_tagger -d "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader brown -d "${NLTK_DATA_DIR}"
RUN python3 -m nltk.downloader wordnet -d "${NLTK_DATA_DIR}"

# Create Unprivlaged User
RUN groupadd -r user && \
  useradd -r -g user -d /home/user -s /sbin/nologin -c "User" user && \
  mkdir /home/user && \
  chown -R user:user /home/user

USER root
WORKDIR /home/user
CMD ["bash"]
