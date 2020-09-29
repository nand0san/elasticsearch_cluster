FROM arm32v7/ubuntu:18.04

RUN set +x \
  && apt-get -qq -y update \
  && apt-get -qq -y upgrade \
  && apt-get -qq -y install curl wget xz-utils nano libatomic1 \
  && apt clean \
  && set -x 

ENV ELK_VERSION=7.6.1

ENV \
  KIBANA_HOME=/usr/share/kibana \
  KIBANA_PACKAGE=kibana-${ELK_VERSION}-amd64.deb

RUN set +x \
  && echo "Create ${KIBANA_HOME}" \
  && mkdir -p ${KIBANA_HOME} \
  && echo "Download from  https://artifacts.elastic.co/downloads/kibana/${KIBANA_PACKAGE} to ${KIBANA_HOME}" \
  && wget -q -O "${KIBANA_HOME}/${KIBANA_PACKAGE}" https://artifacts.elastic.co/downloads/kibana/${KIBANA_PACKAGE} \
  && echo "Install ${KIBANA_PACKAGE} to ${KIBANA_HOME}" \
  && dpkg -i --force-all --ignore-depends=lib6c ${KIBANA_HOME}/${KIBANA_PACKAGE} \
  && set -x

ADD ./kibana.yml /etc/kibana/kibana.yml

RUN cd /root && curl -O https://nodejs.org/dist/v10.19.0/node-v10.19.0-linux-armv7l.tar.xz && tar -xJvf node-v10.19.0-linux-armv7l.tar.xz
RUN rm -rf /usr/share/kibana/node
RUN cp -r /root/node-v10.19.0-linux-armv7l /usr/share/kibana/node
ADD ./kibana.sh ${KIBANA_HOME}/bin/kibana
RUN chmod a+x ${KIBANA_HOME}/bin/kibana

EXPOSE 5601

ADD ./start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]