#!/bin/sh

yum update 
yum -y install openssh-server
systemctl enable sshd
systemctl start sshd
echo "asdzxc" | passwd --stdin root