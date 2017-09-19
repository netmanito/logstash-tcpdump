# Logstash Docker from original elastic docker image

Creates 2 logstash docker container with tcpdump parse options to ne used with Apache kafka as a broker.


### Contents

Logstash Ingest pipeline files sends events to KAFKA


#### logstash-kafka:

Logstash config for receiving logs from tcpdump file and send to *Kafka*

	logstash-kafka/conf.d/
		00-tcpdump-input.conf --> recieves messages from tcpdump `cat tcpdump.log | nc logstash 5046`
		99-output.conf --> sends message to Kafka with the topic tcpdump

#### logstash-tcpdump:

Directory includes some index templates and kibana visualizations example for geoip.

		kibana-search-visualization-test.json --> basic geoip search and map visualization for kibana	
		syslog-index-template.json --> syslog index template with geoip enabled
		filebeat-index-template.json --> filebeat index template with geoip enabled
		logstash-index-template.json --> logstash index template with geoip enabled


Logstash Parser pipeline files processes **data** and sends it to Elasticsearch are in directory **conf.d**

	logstash-tcpdump/conf.d:
		00-kafka-input.conf --> Input data from KAFKA
		10-tcpdump.conf --> parse tcpdump message
		99-output.conf --> output to elasticsearch


These files are suitable for creating either front and back logstash services to work with KAFKA in the middle.


	DATA --> Logstash Ingest --> KAFKA <-- Logstash Parser --> Elasticsearch <-- Kibana

It has been tried with docker-kafka image from https://github.com/wurstmeister/kafka-docker

### Build

Using docker-compose it will build 2 docker containers, one for **ingest** and one for **parser**.

This wont start anky KAFKA service so, you'll need to run a **Kafka** instance in other place and change the IP in *KAFKA_HOST* variable on Dockerfiles and docker-compose.yml to suit your requirements

	docker-composer up

### Use

This configs are based on capturing some data trhough **tcpdump** and saving it to a file *tcpdump.log*

	tcpdump -nS -i wlan0 -s0 -tttt > tcpdump.log

Change wlan0 to the interface where you want to listen with tcpdump.

Once you have tcpdump capturing data, you cand send data in different ways. For example purpores, here we've used a simple cat.

	tail -F tcpdump.log | nc LOGSTASH_INPUT 5046

If you're running with **Kafka** in the middle, topic is set to **tcpdump** and the parsing options are in ** */logstash-tcpdump/conf.d/10-tcpdump.conf***.

### GEOIP

GeoIP is configured on parse options for **srcIP** field, this will get geoposition coords of every IP from the field, and will available for kibana mapping feature.

You need **ingest-geoip** module installed in your elastisearch cluster, just do

	/path/to/elasticsearch/bin/elasticsearch-plugin isntall ingest-geoip

and restart your cluster to make plugin available.

Now you can load the template-mapping to support geoip on your index.

	curl -XPUT 'http://localhost:9200/_template/logstash?pretty' -d@logstash-index-template.json

This will enable geoip on all indices with name **logstash-***

You can then import **kibana-search-visualization-test.json** into your kibana to have an example of map visualization.