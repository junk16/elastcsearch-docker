#!/bin/bash

/usr/local/elasticsearch-1.7.2/bin/elasticsearch -d
/usr/local/kibana-4.1.2-linux-x64/bin/kibana > /dev/null 2>&1 & echo $!

if [[ $1 = "-d" || $2 = "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 = "-bash" || $2 = "-bash" ]]; then
  /bin/bash
fi
