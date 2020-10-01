FROM arm32v7/ubuntu:18.04

RUN set +x \
  && apt-get -qq -y update \
  && apt-get -qq -y upgrade \
  && apt-get -qq -y --no-install-recommends install curl wget nano cron zip unzip \
  && apt-get -qq -y --no-install-recommends install openjdk-11-jdk \
  && apt-get -qq -y --no-install-recommends install apt-transport-https jruby \
  && apt-get -qq -y --no-install-recommends install texinfo build-essential ant git \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* \
  && set -x 


ENV ELK_VERSION=7.6.1

ENV \
  LOGSTASH_HOME=/usr/share/logstash \
  LOGSTASH_PACKAGE=logstash-${ELK_VERSION}.deb

RUN set +x \
  && echo "Create ${LOGSTASH_HOME}" \
  && mkdir -p ${LOGSTASH_HOME} \
  && echo "Download from https://artifacts.elastic.co/downloads/logstash/${LOGSTASH_PACKAGE} to ${LOGSTASH_HOME}" \
  && wget -q -O "${LOGSTASH_HOME}/${LOGSTASH_PACKAGE}" https://artifacts.elastic.co/downloads/logstash/${LOGSTASH_PACKAGE} \
  && echo "Install ${LOGSTASH_PACKAGE} to ${LOGSTASH_HOME}" \
  && dpkg -i --force-all ${LOGSTASH_HOME}/${LOGSTASH_PACKAGE} \
  && set -x

ADD ./fix.sh /root/

ADD ./conf.d/* /etc/logstash/conf.d/

RUN chmod +x /root/fix.sh

RUN /root/fix.sh

ADD ./start.sh /root/

RUN chmod +x /root/start.sh

EXPOSE 1514/udp
EXPOSE 2055/udp
EXPOSE 5044
EXPOSE 9300

CMD [ "/root/start.sh" ]
