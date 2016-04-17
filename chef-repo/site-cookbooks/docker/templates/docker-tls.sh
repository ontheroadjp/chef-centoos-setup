#!/bin/sh

certs_dir="/etc/docker/certs"
    
function _generate_rsa_keys() {
    
    mkdir -p ${certs_dir}
    cd ${certs_dir}
    
    openssl genrsa -aes256 -out ca-key.pem 4096
    openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
    echo "done."
    
    # printf "RSA private key(server-key.pem, server.csr)..."
    openssl genrsa -out server-key.pem 4096
    openssl req -subj "/CN=$(ip r | grep 'docker0' | awk '{print $9}')" -sha256 -new -key server-key.pem -out server.csr
    echo "done."
    
    # printf "sign the public key with our CA(extfile.cnf, ca.pem, ca.srl)..."
    echo subjectAltName = IP:172.17.0.1,IP:10.10.10.20,IP:127.0.0.1 > extfile.cnf
    openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
    echo "done."
    
    # printf "create a client key and certificate signing request(key.pem, client.csr)"
    openssl genrsa -out key.pem 4096
    openssl req -subj '/CN=client' -new -key key.pem -out client.csr
    echo "done."
    
    # printf "create an extensions config file..."
    echo "extendedKeyUsage = clientAuth" > extfile.cnf
    echo "done."
    
    # printf "sign the public..."
    openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile.cnf
    echo "done."
    
    # printf "clean and permission settings..."
    rm -v client.csr server.csr
    chmod -v 0400 ca-key.pem key.pem server-key.pem
    chmod -v 0444 ca.pem server-cert.pem cert.pem
    echo "done."
}

function _restart_docker_daemon() {
    local status
    echo -n "docker daemon restart..."
    systemctl restart docker
    ps aux | grep "/usr/bin/docker daemon \
                             --tlsverify \
                             --tlscacert=/etc/docker/certs/ca.pem \
                             --tlscert=/etc/docker/certs/server-cert.pem \
                             --tlskey=/etc/docker/certs/server-key.pem \
                             -H=tcp://0.0.0.0:2376" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "success"
    else
        echo "error"
    fi
}

function _open_port_2376() {
    echo -n "open port #2376..."
    firewall-cmd --add-port=2376/tcp --zone=public --permanent
    firewall-cmd --reload
}


# Secure by default settings
function _user_permit() {
    user=$1
    home_dir=$(cat /etc/passwd | grep "^${user}:.*" | grep -v "/sbin/nologin" | cut -d ":" -f 6)
    if [ -z ${home_dir} ]; then
        echo "ERROR: ${user} is not general user."
        exit 1
    fi

    # copy Key-pair
    mkdir -pv ${home_dir}/.docker
    cp -v ${certs_dir}/{ca,cert,key}.pem ${home_dir}/.docker
    chown ${user} ${home_dir}/.docker/{ca,cert,key}.pem


    # add settings into .bashrc
    local bashrc=${home_dir}/.bashrc
    echo "" >> ${bashrc}
    echo "# Docker security addition on xxx" >> ${bashrc}
    echo 'export DOCKER_HOST=tcp://127.0.0.1:2376 DOCKER_TLS_VERIFY=1' >> ${bashrc}
    echo "# Finished for Docker security addition." >> ${bashrc}
    echo "" >> ${bashrc}

    # add docker group
    if ! cat /etc/group | grep "^docker:.*$"; then
        groupadd docker
        echo "Create docker group"
    fi

    # add user into docker group
    usermod -aG docker ${user}
    echo "Add user(${user}) into docker group"

}

function _main() {
    if [ $# -eq 0 ]; then
        echo -n "Are you sure you want to generate RSA key-pair?(y/n): "
        read answer
        if [ ${answer} = "y" ]; then
            _generate_rsa_keys
            if [ -f "/etc/docker/certs/ca.pem" ] &&
                [ -f "/etc/docker/certs/server-cert.pem" ] &&
                [ -f "/etc/docker/certs/server-key.pem" ]; then
                _restart_docker_daemon
                _open_port_2376
            fi
        else
            exit 1
        fi
    elif [ $# -eq 1 ]; then
        #echo -n "enter username: "
        #read username
        username=$1
        
        if ! cat /etc/passwd | grep "^${username}:.*"; then
            echo "ERROR: user does not exist."
            exit 1
        fi
        _user_permit ${username}
    else
        echo "ERROR: invalid argument"
        exit 1
    fi
}

_main $@

exit 0
