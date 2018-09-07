FROM debian:stretch-slim

MAINTAINER Taivo Käsper <taivo.kasper@gmail.com>

ENV OMNIDB_VERSION 2.10.0

RUN apt-get update \
      && apt-get install -y curl unzip make build-essential python3-pip libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev xz-utils \
      && curl -Lo /tmp/OmniDB.zip https://github.com/OmniDB/OmniDB/archive/${OMNIDB_VERSION}.zip \
      && unzip /tmp/OmniDB.zip -d /opt/ \
      && rm -f /tmp/OmniDB.zip \
      && mkdir /etc/omnidb \
      && apt-get purge -y curl unzip \
      && rm -rf /var/lib/apt/lists/*
RUN cd /opt/OmniDB-${OMNIDB_VERSION} && pip3 install --upgrade pip==9.0.3 && echo "Begin install cherrypy" && pip3 install cherrypy && echo "Begin install requirements" && pip3 install -r requirements.txt
#RUN cd /opt/OmniDB-${OMNIDB_VERSION} && pip3 install pip --upgrade
#RUN cd /opt/OmniDB-${OMNIDB_VERSION} && pip3 install cherrypy 
#RUN cd /opt/OmniDB-${OMNIDB_VERSION} && pip3 install -r requirements.txt

# Cleanup
# RUN apt-get remove -y curl unzip

EXPOSE 8080

WORKDIR /opt/OmniDB-${OMNIDB_VERSION}/OmniDB

CMD python3 omnidb-server.py -p 8080 -d /etc/omnidb

