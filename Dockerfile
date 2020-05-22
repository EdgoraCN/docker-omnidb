FROM alpine:3.11

MAINTAINER Taivo Käsper <taivo.kasper@gmail.com>

ENV OMNIDB_VERSION 2.17.0

#ENV http_proxy=http://192.168.2.120:3128
#ENV https_proxy=http://192.168.2.120:3128

RUN apk add --no-cache --virtual .build-deps curl libaio unzip g++ python3-dev \
      && apk add --no-cache make wget llvm libaio\
      && apk add --no-cache --update python3 \
      && pip3 install --upgrade pip \
      && apk add postgresql-dev libffi-dev \
      && pip3 install psycopg2 \
      && pip3 install cffi \
      && curl -Lo /tmp/instantclient.zip http://file.edgora.cn/instantclient-basiclite-linux.x64-19.6.0.0.0dbru.zip \
      && unzip /tmp/instantclient.zip -d /opt/ \
      && rm -f /tmp/instantclient.zip \
      && curl -Lo /tmp/OmniDB.zip https://github.com/OmniDB/OmniDB/archive/${OMNIDB_VERSION}.zip \
      && unzip /tmp/OmniDB.zip -d /opt/ \
      && rm -f /tmp/OmniDB.zip \
      && mkdir /etc/omnidb \
      && cd /opt/OmniDB-${OMNIDB_VERSION} \
      && pip3 install cherrypy \
      && pip3 install -r requirements.txt \
      && apk del .build-deps \
      && find /usr/local -name '*.a' -delete \
      && addgroup -S omnidb && adduser -S omnidb -G omnidb \
      && chown -R omnidb:omnidb /opt/OmniDB-${OMNIDB_VERSION} \
      && chown -R omnidb:omnidb /etc/omnidb

ENV ORACLE_BASE /opt/instantclient_19_6
ENV LD_LIBRARY_PATH /opt/instantclient_19_6
ENV TNS_ADMIN    /opt/instantclient_19_6/network/admin
ENV ORACLE_HOME /opt/instantclient_19_6

#ENV http_proxy ""
#ENV https_proxy ""

USER omnidb

EXPOSE 8080 25482

WORKDIR /opt/OmniDB-${OMNIDB_VERSION}/OmniDB

ENTRYPOINT ["python3", "omnidb-server.py", "--host=0.0.0.0", "--port=8080", "-d", "/etc/omnidb"]
