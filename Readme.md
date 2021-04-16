# Logstash tcpdump

Creates a logstash docker container with tcpdump parse options and sends to elasticsearch.

### Contents


#### logstash-tcpdump:

Directory includes some index templates and kibana visualizations example for geoip.

		tcpdump_template.json --> tcpdump template with geoip enabled


Logstash Parser pipeline files processes **data** and sends it to Elasticsearch are in directory **conf.d**

	logstash-tcpdump/conf.d:
		00-tcpdump-input.conf --> Input data from netcat
		10-tcpdump.conf --> parse tcpdump messages
		99-output.conf --> output to elasticsearch defined with variables

### Build

In main directory create a `.env` file with 

```
ES_HOST="192.168.110.205:9200"
LOGSTASH_USER=elastic
PASSWORD=changeme
PATH_CONF=${PWD}/conf.d
PATH_LOGS=${PWD}/logs
```

### Run

Put the tcpdump_template.json on your elasticsearch cluster where data will be sent. Once set, you can run logstash with docker-compose

	docker-compose up
	
### Use

On the host you're going to analyze traffic with **tcpdump**, we're going to run the following.

This configs are based on capturing some data trhough **tcpdump** and saving it to a file *tcpdump.log*

	tcpdump -nS -i wlan0 -s0 -tttt > tcpdump.log

Change `wlan0` to the interface where you want to listen with tcpdump.

Once you have tcpdump capturing data, you cand send data in different ways. For example purpores, here we've used a simple cat.

	tail -F tcpdump.log | nc LOGSTASH_IP 5046

You could also use filebeat but I have not tried yet.

