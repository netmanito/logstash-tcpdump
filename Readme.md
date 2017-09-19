# Logstash Docker from original elastic docker image

Creates a logstash docker container with tcpdump parse options and sends to elasticsearch.

### Contents

#### logstash-tcpdump:

Directory includes some index templates and kibana visualizations example for geoip.

		kibana-search-visualization-test.json --> basic geoip search and map visualization for kibana	
		syslog-index-template.json --> syslog index template with geoip enabled
		filebeat-index-template.json --> filebeat index template with geoip enabled
		logstash-index-template.json --> logstash index template with geoip enabled


Logstash Parser pipeline files processes **data** and sends it to Elasticsearch are in directory **conf.d**

	logstash-tcpdump/conf.d:
		00-tcpdump-input.conf --> Input data from netcat
		10-tcpdump.conf --> parse tcpdump message
		99-output.conf --> output to elasticsearch

### Build

In main directory run 

	sudo docker build -it logstash:tcpdump .

### Run

	sudo docker run -p 5046:5046 -it logstash:tcpdump

### Use

This configs are based on capturing some data trhough **tcpdump** and saving it to a file *tcpdump.log*

	tcpdump -nS -i wlan0 -s0 -tttt > tcpdump.log

Change wlan0 to the interface where you want to listen with tcpdump.

Once you have tcpdump capturing data, you cand send data in different ways. For example purpores, here we've used a simple cat.

	tail -F tcpdump.log | nc LOGSTASH_INPUT 5046

### GEOIP

These options are for elasticsearch **v5.x**, it's not been tried on **ES6** yet.

GeoIP is configured on parse options for **srcIP** field, this will get geoposition coords of every IP from the field, and will available for kibana mapping feature, you can change to **destIP** if you like.

You need **ingest-geoip** module installed in your elastisearch cluster, just do

	/path/to/elasticsearch/bin/elasticsearch-plugin isntall ingest-geoip

and restart your cluster to make plugin available.

Now you can load the template-mapping to support geoip on your index.

	curl -XPUT 'http://localhost:9200/_template/logstash?pretty' -d@logstash-index-template.json

This will enable geoip on all indices with name **logstash-***

You can then import **kibana-search-visualization-test.json** into your kibana to have an example of map visualization.