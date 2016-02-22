#!/bin/sh -xe

./docker/init.sh

## build docker image
#docker build -t nuts/sshd ./docker

# run container
container_id=`docker run -d nuts/chef`

# get IP address
ipaddress=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -q | awk 'NR==1')`

echo '-----------------------------'
echo 'Container ID: '${container_id}
echo 'IPAddress: '${ipaddress}
echo '-----------------------------'

echo 'container_id='${container_id} >> ./docker/conf.txt
echo 'ipaddress='${ipaddress} >> ./docker/conf.txt
chown $(whoami) ./docker/conf.txt

