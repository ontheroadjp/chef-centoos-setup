#!/bin/sh -xe

./docker/create_Dockerfile.sh

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

# Chef の nodes/xxx.json を作成
cp ./docker/node.json ./nodes/${ipaddress}.json

# Chef の実行
#knife solo bootstrap root@${ipaddress} --defaults -i /var/lib/jenkins/.ssh/id_rsa
knife solo bootstrap root@${ipaddress} --defaults || RET=$?


export LANG=ja_JP.UTF-8
cp -r spec/chef ./spec/${ipaddress}
chown jenkins:jenkins ./spec/${ipaddress}
#echo 'Host '${ipaddress} >> $HOME/.ssh/config
#echo 'HostName '${ipaddress} >> $HOME/.ssh/config
#echo 'Port 22' >> $HOME/.ssh/config
#echo 'User root' >> $HOME/.ssh/config
#rake spec:${ipaddress} USER=root KEY=./docker/id_rsa_root.pub TARGET_HOST=${ipaddress}
rake spec:${ipaddress} USER=root KEY=./docker/id_rsa_root.pub TARGET_HOST=${ipaddress} LOGIN_PASSWARD=root rake spec

# コンテナの停止
echo 'stop container: '${container_id}
docker stop ${container_id}

# コンテナの破棄
echo 'remove container: '${container_id}
docker rm ${container_id}

# Chef の nodes/xxxx.json の破棄
echo 'remove ./nodes/'${ipaddress}'.json'
rm ./nodes/${ipaddress}.json

echo 'complete!'
exit $RET

