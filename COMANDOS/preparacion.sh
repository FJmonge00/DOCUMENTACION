$tiposo=$(cat /etc/os-release | head -n3 | grep -i "centos" | wc -l)
if [ $tiposo -gt 0 ] 
    then
        yum reinstall openssh-server
        systemctl restart sshd.service
    else
        dpkg-reconfigure --force openssh-server
        systemctl restart sshd.service

fi
# mkdir /root/.ssh
# cd /root/.ssh
# chmod 600 -R /root/.ssh
# ssh-keygen -C "" -P "" -f "id_rsa"
# echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGAcelujq9Ty6n0jA2MB+X9clxc/uIBVaZterRZH9g0h7dNDV5UARc5tvN19ZcrLk9PF1U5dLZWYcOoGc+OAVyWWOY0C4RCG2CV6g5uUpzRp+xw0v9WX92vuFupEpZdG6t06o1eJ+YqM+0YnUlDGF/VpN5/HJHQweEQ9O0n0E6zd8JId5nR9aVVaAU6myPWTZpSNUqSmglvfjWD8KUcEcacSJBnsV3RTFxDOq3pGHitClqBzyimJyv0PpBYs6WjvULygqcX9nVJIvjB3mOvuhqf/kX5jRVSCMaL+0TC56NBix83lE/ZGETzcXKbC1LPbivZFnd/wABCLnkGuWB8CJ3 root@PC-fran' >> /root/.ssh/known_hosts