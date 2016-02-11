# docker build -t nuts/sshd .
# docker run -d nuts/sshd
# $ ssh nobita@xxx.xxx.xxx.xxx or ssh root@xxx.xxx.xxx.xxx

FROM centos:6

RUN yum install -y passwd
RUN yum install -y openssh
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
RUN yum install -y sudo

## create user
RUN useradd nobita
RUN passwd -f -u nobita
RUN mkdir -p /home/nobita/.ssh; chown nobita /home/nobita/.ssh; chmod 700 /home/nobita/.ssh
#ADD ./nobita/id_rsa.pub /home/nobita/.ssh/authorized_keys
ADD ./id_rsa_nobita.pub /home/nobita/.ssh/authorized_keys
RUN chown nobita /home/nobita/.ssh/authorized_keys; chmod 600 /home/nobita/.ssh/authorized_keys

## modify root
RUN echo root | passwd --stdin root
RUN mkdir -p /root/.ssh; chown root /root/.ssh; chmod 700 /root/.ssh
#ADD ./root/id_rsa.pub /root/.ssh/authorized_keys
ADD ./id_rsa_root.pub /root/.ssh/authorized_keys
RUN chown root /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys

## setup sudoers
RUN echo "nobita    ALL=(ALL)       ALL" >> /etc/sudoers.d/nobita

## setup sshd and generate ssh-keys by init script
ADD ./sshd_config /etc/ssh/sshd_config
RUN /etc/init.d/sshd start
RUN /etc/init.d/sshd stop

## Seems we cannnot fix public port number
EXPOSE 22
# EXPOSE 49222:22

CMD ["/usr/sbin/sshd", "-D"]
#CMD ["service sshd start"] 

