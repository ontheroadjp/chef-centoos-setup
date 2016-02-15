#!/bin/sh -xe

. docker/conf.txt

# Chef の実行
#knife solo bootstrap root@${ipaddress} --defaults -i /var/lib/jenkins/.ssh/id_rsa
knife solo bootstrap root@${ipaddress} --defaults || RET=$?

exit $RET

