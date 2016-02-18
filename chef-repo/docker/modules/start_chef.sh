#!/bin/sh -xe

. docker/conf.txt

# Chef の nodes/xxx.json を作成
cp ./docker/docker_node_all.json ./nodes/${ipaddress}.json
chown jenkins ./nodes/${ipaddress}.json

