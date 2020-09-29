#!/bin/bash

service elasticsearch start
OUTPUT_LOGFILES+="/var/log/elasticsearch/elasticsearch.log "

touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES &
wait