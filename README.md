# redesign centos7

This repo creates the redesign/centos7 box for use in Vagrant, VMWare or Azure.
Packer is used as the build tool, and Ansible is used as the provisioner.

Please note that **Packer v1.1.1 has been used.**

## Vagrant

The box is downloadable with a single command, but the included
Vagrantfile works better.

```
vagrant init redesign/centos7
```

## Azure

To use this in Azure you need a subscription, a storage account and
a resource group. Add your credentials in your environment variables.

## Development

Try this:

```
make build
```

It will create a virtualbox vm with centos7

The packer-centos75.json file controls the packer process:

- It downloads and boots the ISO
- It serves the kickstart file.
- The kickstart folder holds the primary boot install for centos7.

If it is good, then upload to https://app.vagrantup.com
