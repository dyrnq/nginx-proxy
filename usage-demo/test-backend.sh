#!/bin/bash
container=${1:-w1}

while true;do 
    docker stop "${container}";
    sleep 20s;
    docker start "${container}";
done;