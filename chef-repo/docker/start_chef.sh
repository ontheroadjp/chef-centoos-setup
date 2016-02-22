#!/bin/sh -xe

. docker/conf.txt

# create 'nodes/xxx.json'
cp ./docker/node.json ./nodes/${ipaddress}.json
chown $(whoami) ./nodes/${ipaddress}.json

