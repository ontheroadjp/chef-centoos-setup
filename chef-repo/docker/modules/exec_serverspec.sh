#!/bin/sh -xe

. docker/conf.txt

lang=$(echo $LANG)
lc_lang=$(echo $LC_LANG)

export LANG='ja_JP.UTF-8'
export LC_LANG='ja_JP.UTF-8'

cp -r spec/chef ./spec/${ipaddress}
chown jenkins:jenkins ./spec/${ipaddress}
rake spec:${ipaddress} USER=root KEY=../docker/id_rsa_root.pub TARGET_HOST=${ipaddress} LOGIN_PASSWARD=root rake spec || RET=$?

export LANG=${lang}
export LANG=${lc_lang}

exit $RET

