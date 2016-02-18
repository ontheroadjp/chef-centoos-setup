#!/bin/sh -xe

. docker/conf.txt

CHEFHOME=../

# Chef の実行
#knife solo bootstrap root@${ipaddress} --defaults -i /var/lib/jenkins/.ssh/id_rsa
# knife solo bootstrap root@${ipaddress} -c ${CHEFHOME}/.chef/knife.rb -j ${CHEFHOME}/nodes/${ipaddress}.json --defaults || RET=$?
knife solo bootstrap root@${ipaddress} --defaults || RET=$?

exit $RET

