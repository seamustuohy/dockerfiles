FROM debian:buster
MAINTAINER Seamus Tuohy (code@seamustuohy.com)

USER root
RUN apt-get update && apt-get install -y \
    git \
    exiftool \
    python3-dev \
    python3-pip \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade setuptools wheel
RUN pip3 install --upgrade pandas progress future requests beautifulsoup4
RUN git clone https://github.com/cmu-sei/cyobstract.git \
    && cd cyobstract \
    && python3 setup.py install

COPY get_indicators_from_url.py /usr/local/bin/

USER root
WORKDIR /root
ENTRYPOINT [ "python3", "/usr/local/bin/get_indicators_from_url.py" ]
