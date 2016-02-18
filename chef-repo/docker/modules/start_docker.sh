#!/bin/sh -xe

./docker/modules/create_Dockerfile.sh

# Docker イメージの作成
docker build -t nuts/sshd ./docker

# Docker コンテナの生成
container_id=`docker run -d nuts/sshd`

# 生成したコンテナの IP アドレス取得
ipaddress=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -q | awk 'NR==1')`

echo '-----------------------------'
echo 'Container ID: '${container_id}
echo 'IPAddress: '${ipaddress}
echo '-----------------------------'

echo 'container_id='${container_id} >> ./docker/conf.txt
echo 'ipaddress='${ipaddress} >> ./docker/conf.txt
chown jenkins ./docker/conf.txt

