FROM openjdk:8

ENV JADX_VERSION 0.7.1

USER root
RUN apt-get update && apt-get install -y \
    git \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN cd /usr/local/src \
    && git clone https://github.com/skylot/jadx.git \
    && cd jadx \
    && git checkout "v0.7.1" \
    && ./gradlew dist \
    && ln -snf /usr/local/src/jadx/build/jadx/bin/jadx-gui /usr/local/bin/jadx-gui \
    && ln -snf /usr/local/src/jadx/build/jadx/bin/jadx /usr/local/bin/jadx

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

USER root
WORKDIR /home/user/workdir/malware
CMD ["jadx-gui"]
