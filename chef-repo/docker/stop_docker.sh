#!/bin/sh -xe

. docker/conf.txt

# stop container
echo 'stop container: '${container_id}
docker stop ${container_id}

# remove container
echo 'remove container: '${container_id}
docker rm ${container_id}

echo '-----------------------------'
echo 'Container ID: '${container_id}
echo 'IPAddress: '${ipaddress}
echo '-----------------------------'

rm docker/conf.txt
