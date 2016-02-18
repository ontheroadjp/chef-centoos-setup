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

# data_bag_key
openssl rand -base64 512 > $(dirname $0)/../.chef/data_bag_key

# password
exe='echo crypt("'${password}'","$6$".substr(uniqid(),0,8));'
encrypt_pass=$(php -r "${exe}")

# sshkey
sshkey=$(cat $HOME/.ssh/id_rsa.pub)

out=${username}.json
echo '{' >> $out
echo '  "id": "'${username}'",' >> $out
echo '  "shell": "/bin/bash",' >> $out
echo '  "password": "'${encrypt_pass}'",' >> $out
echo '  "wheel": '${wheel}',' >> $out
echo '  "sshkey": "'${sshkey}'"' >> $out
echo '}' >> $out

#knife data bag create -d --secret-file .chef/data_bag_key --local users $username
    



