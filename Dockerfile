
FROM fedora:37

ARG ZOOKEEPER_VERSION=3.8.1

RUN dnf update -y && \
    dnf install -y java-1.8.0-openjdk net-tools && \
    dnf update -y && dnf clean all

RUN echo -e "\n* soft nofile 65536\n* hard nofile 65536" >> /etc/security/limits.conf

ADD zookeeper-${ZOOKEEPER_VERSION}.tar.gz /usr/local/
RUN ln -s /usr/local/apache-zookeeper-${ZOOKEEPER_VERSION}-bin /usr/local/zookeeper

ENV ZOOKEEPER_HOME /usr/local/zookeeper
ENV PATH $PATH:$ZOOKEEPER_HOME/bin
COPY zookeeper/* $ZOOKEEPER_HOME/conf/

COPY start-zookeeper /

CMD /start-zookeeper

EXPOSE 2181

