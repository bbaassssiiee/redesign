# Base images

## Usage

Centos 6 is created in this directory with Vagrant, Packer and Ansible.

### Enter these commands with vagransible as the work directory

    'make prepare' # download the required roles
    'make demo'    # create a centos base images for virtualbox

___

- Vagrant allows users to create disposable virtual machines for their projects.
- Packer creates base images, for Vagrant and also for the clouds.
- Ansible provisions these machines.

___
### make

This project has a Makefile that wraps some longer commands and their dependencies.

    make prepare    # install dependencies
    make packer     # build the centos image with packer
    make box        # add the packer built box for use by vagrant
    make up         # vagrant up, in an idempotent way

___
### Ansible

The packer.yml playbook defines what is done during the Packer run

The vagrant.yml playbook defines what is done during the Vagrant run.
___
**Hardening**

To show how security can be improved with Ansible:

    'make harden'  # run the RHEL6-STIG role to create a USG compliant VM

    'make audit'   # check if the VM is indeed compliant

The Vagrantfile defines a virtual machine with Centos 6, you can login to it:

    vagrant ssh

___
[@bbaassssiiee](https://twitter.com/bbaassssiiee)
___
