FROM golang:latest

ENV \
  ELK_VERSION=7.6.1 \
  GOARCH=arm

RUN \
  go get github.com/elastic/beats; exit 0 \
  && cd /go/src/github.com/elastic/beats/filebeat/ \
  && git checkout "v${ELK_VERSION}" 

RUN \
  wget -q https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${ELK_VERSION}-amd64.deb \
  && dpkg -i --force-all filebeat-${ELK_VERSION}-amd64.deb 

 RUN \
   git clone https://github.com/tsg/go-daemon.git \
   && cd go-daemon \
   && cp src/god.c ./ \
   && make \
   && make install

RUN cd /go/src/github.com/elastic/beats/filebeat/ \
  && GOARCH=arm go build \
  && cp -r /go/src/github.com/elastic/beats/filebeat/filebeat /usr/share/filebeat/bin/ \
  && cp /usr/bin/god /usr/share/filebeat/bin/filebeat-god 

ADD ./filebeat.yml /etc/filebeat/

ADD ./start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 2000
EXPOSE 2514/udp

CMD "start.sh"