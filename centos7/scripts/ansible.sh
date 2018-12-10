#!/bin/bash -e
# prepare ansible virtual machine for use of ansible

/usr/sbin/groupadd --system ansible
/usr/sbin/useradd ansible --system -g ansible -G wheel -d /home/ansible -c "Deployment NPA"
# set password
echo "$ARM_CLIENT_SECRET" | passwd --stdin ansible
mkdir -pm 700 /home/ansible/.ssh
chown -R ansible:ansible /home/ansible/.ssh

# give sudo access (grants all permissions to user ansible)
echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible
chmod 0440 /etc/sudoers.d/ansible

echo 'nameserver 1.1.1.1' > /etc/resolv.conf
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

yum update -y ca-certificates
yum install -y epel-release
yum install -y ansible
yum install -y python-pip

pip install --upgrade --force setuptools
pip install --upgrade --force pip
