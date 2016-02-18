#!/bin/sh -xe

# ------------------------------------
# 既存 Dockerfile の削除
# ------------------------------------
dockerfile='./docker/Dockerfile'
if [ -f $dockerfile ]; then
    sudo rm -f $dockerfile
fi

# ------------------------------------
# RSA キーペアの生成
# ------------------------------------
file=$HOME/.ssh/id_rsa
if [ ! -f $file ]; then
    ssh-keygen -f ${file} -t rsa -N ""
fi
cp -f ${file}.pub ./docker/id_rsa_$(whoami).pub

# ------------------------------------
# Dockerfile の生成
# ------------------------------------
echo '# docker build -t nuts/sshd .' >> $dockerfile
echo '# docker run -d nuts/sshd' >> $dockerfile
echo '# $ ssh nobita@xxx.xxx.xxx.xxx or ssh root@xxx.xxx.xxx.xxx' >> $dockerfile
echo '' >> $dockerfile

echo 'FROM centos:6' >> $dockerfile
echo '' >> $dockerfile

echo 'RUN yum install -y passwd' >> $dockerfile
echo 'RUN yum install -y openssh' >> $dockerfile
echo 'RUN yum install -y openssh-server' >> $dockerfile
echo 'RUN yum install -y openssh-clients' >> $dockerfile
echo 'RUN yum install -y sudo' >> $dockerfile
echo '' >> $dockerfile


if [ "$(whoami)" != "root" ]; then
    echo '# create user' >> $dockerfile
    echo 'RUN useradd '$(whoami) >> $dockerfile
    echo 'RUN echo '$(whoami)' | passwd --stdin '$(whoami) >> $dockerfile
    echo 'RUN mkdir -p /home/'$(whoami)'/.ssh; chown '$(whoami)' /home/'$(whoami)'/.ssh; chmod 700 /home/'$(whoami)'/.ssh' >> $dockerfile
    echo 'ADD ./id_rsa_'$(whoami)'.pub /home/'$(whoami)'/.ssh/authorized_keys' >> $dockerfile
    echo 'RUN chown '$(whoami)' /home/'$(whoami)'/.ssh/authorized_keys; chmod 600 /home/'$(whoami)'/.ssh/authorized_keys' >> $dockerfile
    echo '' >> $dockerfile
fi

echo '## modify root' >> $dockerfile
echo 'RUN echo root | passwd --stdin root' >> $dockerfile
echo 'RUN mkdir -p /root/.ssh; chown root /root/.ssh; chmod 700 /root/.ssh' >> $dockerfile
echo 'ADD ./id_rsa_'$(whoami)'.pub /root/.ssh/authorized_keys' >> $dockerfile
echo 'RUN chown root /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys' >> $dockerfile
echo '' >> $dockerfile

if [ "$(whoami)" != "root" ]; then
    echo '## setup sudoers' >> $dockerfile
    echo 'RUN echo "Defaults:'$(whoami)' !requiretty" >> /etc/sudoers.d/'$(whoami) >> $dockerfile
    echo 'RUN echo "'$(whoami)' ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/'$(whoami) >> $dockerfile
    echo '' >> $dockerfile
fi

echo '## setup sshd' >> $dockerfile
echo 'ADD ./sshd_config /etc/ssh/sshd_config' >> $dockerfile
echo 'RUN /etc/init.d/sshd start' >> $dockerfile
echo 'RUN /etc/init.d/sshd stop' >> $dockerfile
echo '' >> $dockerfile

echo '## Seems we cannnot fix public port number' >> $dockerfile
echo 'EXPOSE 22' >> $dockerfile
echo '# EXPOSE 49222:22' >> $dockerfile
echo '' >> $dockerfile

echo 'CMD ["/usr/sbin/sshd", "-D"]' >> $dockerfile

