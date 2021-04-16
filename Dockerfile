FROM docker.elastic.co/logstash/logstash:7.9.0
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
ADD conf.d/ /usr/share/logstash/pipeline/
ADD config/ /usr/share/logstash/config/
ARG ES_HOST ${ES_HOST}
ARG LOGSTASH_USER ${LOGSTASH_USER}
ARG PASSWORD ${PASSWORD}
RUN /usr/share/logstash/bin/logstash-plugin install logstash-codec-gzip_lines
