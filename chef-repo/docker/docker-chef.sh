#!/bin/sh

# Docker コンテナの生成
container_id=$(docker run -d nuts/chef)

# 生成したコンテナの IP アドレス取得
ipaddress=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -q | awk 'NR==1'))

echo '-----------------------------'
echo 'Container ID: '${container_id}
echo 'IPAddress: '${ipaddress}
echo '-----------------------------'

# Chef の nodes/xxx.json を作成
cp ./docker/node.json ./nodes/${ipaddress}.json

# Chef の実行
#knife solo bootstrap root@${ipaddress} --defaults -i /var/lib/jenkins/.ssh/id_rsa
knife solo bootstrap root@${ipaddress} --defaults || RET=$?

# serverspec の実行
#lang=$(echo $LANG)
#lc_all=$(echo $LC_ALL)
#export LANG=ja_JP.UTF-8
#export LC_ALL=ja_JP.UTF-8
#rake spec:${ipaddress} USER=root KEY=./docker/id_rsa_root.pub TARGET_HOST=${ipaddress}
#rake spec:${ipaddress} USER=root KEY=./docker/id_rsa_root.pub TARGET_HOST=${ipaddress} LOGIN_PASSWARD=root rake spec
#rake spec:${ipaddress} --task
rake spec:${ipaddress}
#export LANG=${lang}
#export LC_ALL=${lc_all}

# Chef の nodes/xxxx.json の破棄
echo -e "\033[1;33mremove ./nodes/${ipaddress}.json\033[0m"
rm ./nodes/${ipaddress}.json

# コンテナの停止
echo -e "\033[1;33mstop container: ${container_id}\033[0m"
docker stop ${container_id}

# コンテナの破棄
echo -e "\033[1;33mremove container: ${container_id}[0m"
docker rm ${container_id}

echo -e "\033[1;33mcomplete![0m"
exit $RET

