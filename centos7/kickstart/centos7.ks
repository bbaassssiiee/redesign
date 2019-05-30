# Locale
lang en_US.UTF-8
keyboard --vckeymap=us --xlayouts='us'
timezone UTC

# Authentication
auth --enableshadow --passalgo=sha512
rootpw vagrant

# Use CDROM installation media
cdrom

## Disk Partitioning
bootloader --location=mbr
zerombr
clearpart --all --initlabel
part /boot    --size 500      --asprimary
part pv.01    --size 1        --grow

volgroup rootvg pv.01
logvol swap            --fstype swap 	--name=swaplv     --vgname=rootvg --size=2048
logvol /data           --fstype xfs 	--name=DataLV     --vgname=rootvg --size=512 --grow
logvol /home           --fstype xfs 	--name=HomeLV     --vgname=rootvg --size=512 --grow
logvol /tmp            --fstype xfs 	--name=TmpLV      --vgname=rootvg --size=1024
logvol /var            --fstype xfs 	--name=VarLV      --vgname=rootvg --size=2048 --grow
logvol /var/log        --fstype xfs	--name=VarLogLV   --vgname=rootvg --size=1024
logvol /var/log/audit  --fstype xfs	--name=VarLogAuditLV   --vgname=rootvg --size=1024
logvol /               --fstype xfs 	--name=rootvg-root     --vgname=rootvg --size=4096
# Run the Setup Agent on first boot
firstboot --disable

# Network information
network --bootproto=dhcp --noipv6 --activate --hostname=redesign
firewall --enabled --service=ssh
selinux --permissive
# Reboot the machine after successful installation
reboot --eject

%packages --nobase --ignoremissing --excludedocs --instLangs=en_US.utf8
@Core
acpid
libselinux-python
libsemanage-python
openssh-clients
python-httplib2
sudo
make
wget
net-tools
bind-utils
yum-utils

# for vagrant
nfs-utils
nfs-utils-lib
portmap
# in cloud
dwz
fxload
gpg-pubkey
hypervkvpd
libsysfs
perl-srpm-macros
python-pyasn1
python-passlib
python2-jmespath
redhat-rpm-config
zip
chrony
selinux-policy-mls

## Remove unnecessary packages
-avahi
-avahi-libs
-avahi-autoipd
-bitstream-vera-fonts
-aic94xx-firmware
-alsa-firmware
-alsa-tools-firmware
-ivtv-firmware
-iwl100
-iwl*-firmware
-iwl1000
-iwl3945
-iwl4965
-iwl7260
-libmpc
-libsysfs
-mpfr
-rdma
%end

%post
/usr/bin/yum -y upgrade
package-cleanup --oldkernels --count=1yum in
sed -i 's/rhgb quiet//' /etc/grub.conf
# for ansible etc.
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

%end
