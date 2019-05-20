FROM docker.elastic.co/logstash/logstash:6.4.0
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
ARG ES_HOST="127.0.0.1"
ARG ES_PORT="9200"
ENV HOSTS="$ES_HOST:$ES_PORT"
ADD conf.d/ /usr/share/logstash/pipeline/
ADD config/ /usr/share/logstash/config/
