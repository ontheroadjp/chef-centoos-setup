#!/bin/sh -xe

# RSA キーペアの生成
#file=$HOME/.ssh/id_rsa.pub
#if [ ! -f $file ]; then
#    ssh-keygen -t rsa -P "" << EOF
#    EOF
#fi
#cp $file ./

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
cp ./docker/jenkins.json ./nodes/${ipaddress}.json

# Chef の実行
#knife solo bootstrap root@${ipaddress} --defaults -i /var/lib/jenkins/.ssh/id_rsa
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

