FROM ubuntu:16.04

MAINTAINER Aaron Clark <http://epochmod.com/>

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update &&\
    apt-get install -y wget lib32gcc1 lib32stdc++6 redis-server binutils

ADD ./steam /home/steam

CMD exec /home/steam/init.sh