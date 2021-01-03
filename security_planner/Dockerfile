FROM node:15
MAINTAINER Seamus Tuohy (code@seamustuohy.com)

USER root
RUN apt-get update && apt-get install -y \
    ca-certificates \
    --no-install-recommends \
    && update-ca-certificates \ 
    && rm -rf /var/lib/apt/lists/*

# Create Unprivlaged User
RUN groupadd -r user && \
  useradd -r -g user -d /home/user -s /sbin/nologin -c "User" user && \
  mkdir /home/user && \
  chown -R user:user /home/user

EXPOSE 8080

USER user
WORKDIR /home/user
RUN git clone https://github.com/consumerreports/securityplanner.git
RUN cd securityplanner
COPY modernizrrc /home/user/securityplanner/.modernizrrc
RUN npm install --force

USER user
WORKDIR /home/user
CMD ["bash"]
