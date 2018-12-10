#!/bin/bash -e
# create deploy user and group
/usr/sbin/groupadd deploy
/usr/sbin/useradd deploy -g deploy -G wheel -d /home/deploy -c "deploy"
# add deploy's public key - user can ssh without password
mkdir -pm 700 /home/deploy/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDQe3Vwcu+h+Zv1J79HOChTGNI5ReFocc0+lkYpZIbul1ws+QXAOwTZv/809lAyTCA1mN/dCM0dYAuUyUuLq7yV/yh7AJAADo/6YhWMPnAdH/hsCypEnBauYgEGpcDb/qxjuzpDokr7ablmtVIBa0u7eclBT7RrSB0EjdGZq+83rMv3cvTvcj7M/9eQ/7LvOCjMo4IY0qs6xFNEF2ibPUWPEPG40YmTCMTef9goxOuFrsSSxTRsYaNE9+4SZuwilJ5H7BFJjojtJTNJtuenHOhO/ydKJ/9d0G0zUqxmdHbqMWfZEU+u7s4HmmX8SvPtenufeH9Dayu3ugwLIXLp9ib deploy' > /home/deploy/.ssh/authorized_keys
chmod 0600 /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh

# give sudo access (grants all permissions to user deploy)
echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/deploy
chmod 0440 /etc/sudoers.d/deploy

# set password
echo "deploy" | passwd --stdin deploy
