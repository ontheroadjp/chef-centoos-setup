#!/bin/sh

export EDITOR=vim
#export EDITOR='atom -w'
#export EDITOR='subl -w'

printf "enter username : "
read username

printf "enter password : "
read password

printf "add wheel?(true/false) : "
read wheel

if [ ${wheel} != "true" ] || [ ${wheel} != "false" ]; then
    echo "ERROR: wheel value must be true or false."
    echo "Please try again."
    exit 1
fi

# data_bag_key
if [ ! -f $(dirname $0)/../.chef.data_bag_key ]; then
    openssl rand -base64 512 > $(cd $(dirname $0);pwd)/../.chef/data_bag_key
fi

# password
exe='echo crypt("'${password}'","$6$".substr(uniqid(),0,8));'
encrypt_pass=$(php -r "${exe}")

# sshkey
sshkey=$(cat $HOME/.ssh/id_rsa.pub)

out=${username}.json
cat <<-EOF > ${out}
{
    "id": "${username}",
    "shell": "/bin/bash",
    "password": "${encrypt_pass}",
    "wheel": ${wheel},
    "sshkey": "${sshkey}"
}
EOF

exit 0
