#!/bin/sh -xe

. docker/conf.txt

# Chef の nodes/xxxx.json の破棄
echo 'remove ./nodes/'${ipaddress}'.json'
rm ./nodes/${ipaddress}.json

