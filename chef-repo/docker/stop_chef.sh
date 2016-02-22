#!/bin/sh -xe

. docker/conf.txt

# delete 'nodes/xxxx.json'
echo 'remove ./nodes/'${ipaddress}'.json'
rm ./nodes/${ipaddress}.json

