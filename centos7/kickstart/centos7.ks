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
network  --bootproto=dhcp --ipv6=auto --activate --hostname=localhost.localdomain
firewall --disabled
selinux --permissive
# Reboot the machine after successful installation
reboot --eject

%packages --ignoremissing
@core
sudo
make
wget
net-tools
bind-utils
yum-utils

# for guest additions
gcc
cpp
bzip2
libstdc++-devel
kernel-devel
kernel-headers
# for guest tools
checkpolicy
selinux-policy-devel

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
-perl
-gtk2
-libX11
-hicolor-icon-theme
-avahi
-avahi-libs
-avahi-autoipd
-bitstream-vera-fonts
-aic94xx-firmware
-alsa-firmware
-alsa-tools-firmware
-ivtv-firmware
-iwl100
-iwl100-firmware
-iwl105-firmware
-iwl135-firmware
-iwl1000
-iwl1000-firmware
-iwl2000-firmware
-iwl2030-firmware
-iwl3160-firmware
-iwl3945
-iwl3945-firmware
-iwl4965
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6000g2b-firmware
-iwl6050-firmware
-iwl7260
-iwl7260-firmware
-libmpc
-libsysfs
-mpfr
-rdma
%end

%post
#/usr/bin/yum -y upgrade
package-cleanup --oldkernels --count=1yum in
sed -i 's/rhgb quiet//' /etc/grub.conf
# for ansible etc.
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

%end
