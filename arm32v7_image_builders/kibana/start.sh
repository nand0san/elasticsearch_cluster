#!/bin/bash

service kibana start
OUTPUT_LOGFILES+="/var/log/kibana/kibana.stdout"

touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES &
wait