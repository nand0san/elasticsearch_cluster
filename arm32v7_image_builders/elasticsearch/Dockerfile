FROM arm32v7/ubuntu:18.04

RUN set +x \
  && apt-get -qq -y update \
  && apt-get -qq -y upgrade \
  && apt-get -qq -y --no-install-recommends install curl wget nano tzdata cron  \
  && apt-get -qq --no-install-recommends -y install openjdk-11-jdk \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* \
  && set -x 

ENV ELK_VERSION=7.6.1

ENV \
  ES_VERSION=${ELK_VERSION} \
  ES_HOME=/usr/share/elasticsearch \
  JAVA_HOME=/usr/lib/jvm/java-11-openjdk-armhf \
  ES_PACKAGE=elasticsearch-${ELK_VERSION}-no-jdk-amd64.deb

RUN set +x \
  && echo "Create ${ES_HOME}" \
  && mkdir -p ${ES_HOME} \
  && echo "Download from  https://artifacts.elastic.co/downloads/elasticsearch/${ES_PACKAGE} to ${ES_HOME}" \
  && wget -q -O "${ES_HOME}/${ES_PACKAGE}" https://artifacts.elastic.co/downloads/elasticsearch/${ES_PACKAGE} \
  && echo "Install ${ES_PACKAGE} to ${ES_HOME}" \
  && dpkg -i --force-all --ignore-depends=lib6c ${ES_HOME}/${ES_PACKAGE} \
  && set -x

#TODO: Fix dpkg status /var/lib/dpkg/status
#Status: install ok installed
#Depends: bash (>= 4.1), lsb-base (>= 4), adduser, coreutils (>= 8.4)

ADD ./elasticsearch.yml /etc/elasticsearch/

ADD ./jvm.options /etc/elasticsearch/

ADD ./elasticsearch /etc/default/

ADD ./start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 9200

VOLUME /var/lib/elasticsearch

CMD [ "/usr/local/bin/start.sh" ]