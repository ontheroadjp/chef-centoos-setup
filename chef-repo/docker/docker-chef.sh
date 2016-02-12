#!/bin/sh

# Docker イメージの作成
docker build -t nuts/sshd .

# Docker コンテナの生成
container_id=`docker run -d nuts/sshd`

# 生成したコンテナの IP アドレス取得
ipaddress=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps -q | awk 'NR==1')`

echo '-----------------------------'
echo 'Container ID: '${container_id}
echo 'IPAddress: '${ipaddress}
echo '-----------------------------'

# Chef の nodes/xxx.json を作成
#rm ../nodes/172.17.0.*.json
#cp ./template.json ../nodes/${ipaddress}.json
rm ./nodes/172.17.0.*.json
cp ./docker/template.json ./nodes/${ipaddress}.json

# Chef の実行
knife solo bootstrap root@${ipaddress} --defaults 

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

