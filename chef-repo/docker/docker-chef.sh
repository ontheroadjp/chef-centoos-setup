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
#cp -r spec/docker ./spec/${ipaddress}
mkdir ./spec/${ipaddress}
#chown $(whoami) ./spec/${ipaddress}
#rake spec:${ipaddress} USER=root KEY=./docker/id_rsa_root.pub TARGET_HOST=${ipaddress}
#rake spec:${ipaddress} USER=root KEY=./docker/id_rsa_root.pub TARGET_HOST=${ipaddress} LOGIN_PASSWARD=root rake spec
#rake spec:${ipaddress} --task
rake spec:${ipaddress}
#export LANG=${lang}
#export LC_ALL=${lc_all}
rm -rf ./spec/${ipaddress}

# Chef の nodes/xxxx.json の破棄
echo 'remove ./nodes/'${ipaddress}'.json'
rm ./nodes/${ipaddress}.json

# コンテナの停止
echo 'stop container: '${container_id}
docker stop ${container_id}

# コンテナの破棄
echo 'remove container: '${container_id}
docker rm ${container_id}

echo 'complete!'
exit $RET

