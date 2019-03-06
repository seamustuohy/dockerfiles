FROM python:2.7-alpine

ENV path "WIKIPATH"
ENV url "URL"

RUN apk add --no-cache git
RUN mkdir /data
RUN mkdir /wikiteam
RUN git clone https://github.com/WikiTeam/wikiteam.git /wikiteam

WORKDIR /wikiteam
RUN pip install --upgrade -r requirements.txt

# Get script to run wiki downloader
COPY get_wiki.sh /wikiteam/get_wiki.sh

WORKDIR /data
CMD ["sh", "-c", "/wikiteam/get_wiki.sh"]