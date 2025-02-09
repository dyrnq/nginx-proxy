#!/bin/bash

while true; do
    # sleep 1
    code=$(curl -o /dev/null -s -w "%{http_code}" http://127.0.0.1:9971)
    if [ "${code}" = "200" ]; then
        :
    else
        echo "${code} ERROR date: $(date)"
    fi

done