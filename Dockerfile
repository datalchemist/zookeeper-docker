FROM eclipse-temurin:8-jdk-alpine

MAINTAINER datalchemist

ENV ZOOKEEPER_VERSION 3.4.14

#Download Zookeeper
COPY download-zookeeper.sh /tmp

RUN \
 apk --update add gpgme bash curl jq && \
 /tmp/download-zookeeper.sh && \
 mkdir -p /opt && \
 tar -xzf /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C /opt && \
 mv /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo_sample.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg && \
 sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data && \
 ln -s /opt/zookeeper-${ZOOKEEPER_VERSION} /opt/zookeeper && \
 apk del gpgme curl jq && rm -rf /var/cache/apk/*

ADD start-zk.sh /usr/bin/start-zk.sh 
EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper-${ZOOKEEPER_VERSION}

VOLUME ["/opt/zookeeper-${ZOOKEEPER_VERSION}/conf", "/opt/zookeeper-${ZOOKEEPER_VERSION}/data"]

CMD ["/bin/sh", "/usr/bin/start-zk.sh"]
