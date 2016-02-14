#!/bin/sh

file=$HOME/.ssh/id_rsa.pub

if [ ! -f $file ]; then
    ssh-keygen -t rsa
fi

cp $file ./

echo 'complete!'


