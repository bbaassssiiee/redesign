# Make a base box for Azure and VirtualBox
#
FLAVOR=centos75
PROVIDER ?= virtualbox
DOWNLOADS=/Users/Shared

# export these for your product
ARM_RESOURCE_GROUP=my-res-grp
ARM_STORAGE_ACCOUNT=mystorage

.PHONY: help
help:
	@echo 'Usage:'
	@echo "    'make check' to verify dependencies"
	@echo "    'make prepare' to set up local tools"
	@echo "    'make build' to create a ${FLAVOR} box for VirtualBox"
	@echo "    'make vmware' to create a ${FLAVOR} box for VMWare"
	@echo "    'make azurevm' to create a ${FLAVOR} box for Azure"
	@echo "    'make install' load the box to test it"
	@echo "    'make test' to test the box"
	@echo "    'make clean' to start all over again"
	@echo

.PHONY: check
check:
	test -x /usr/local/bin/virtualbox
	test -x /usr/local/bin/vagrant
	vagrant version
	test -x /usr/local/bin/packer
	packer version
	test -x /usr/local/bin/ansible-lint
#	vagrant validate
#	packer validate packer-${FLAVOR}.json
#	packer inspect packer-${FLAVOR}.json > /dev/null 2>&1
	ansible-lint ansible/*.yml || /usr/bin/true

.PHONY: prepare
prepare:
	@brew config || brew open
#	@brew install azure-cli || brew upgrade azure-cli
	@brew install terraform || brew upgrade terraform
	test -x /usr/local/bin/virtualbox || brew install virtualbox
	test -x /usr/local/bin/vagrant || brew install vagrant
	test -x /usr/local/bin/packer || brew install packer
	brew upgrade packer || /usr/bin/true
	packer version
	@vagrant plugin uninstall vagrant-vbguest || /usr/bin/true
	@vagrant plugin install vagrant-vbguest
	ansible-galaxy install --force -p ansible/roles -r ansible/requirements.yml

.PHONY: az-login
az-login:
	az login --allow-no-subscriptions > ~/.azure.json
	az account set --subscription ${ARM_SUBSCRIPTION_ID}
	az account show --query "{ subscription_id: id }"

.PHONY: az-group
az-group:
	az group create -n ${ARM_RESOURCE_GROUP} -l westeurope

.PHONY: az-env
az-env:
	ARM_CLIENT_ID=$(shell cat ~/.az_principal | jq -r .client_id)
	ARM_CLIENT_SECRET=$(shell cat ~/.az_principal | jq -r .client_secret)
	ARM_TENANT_ID=$(shell cat ~/.az_principal | jq -r .tenant_id)
	ARM_RESOURCE_GROUP=$(ARM_RESOURCE_GROUP)
	ARM_STORAGE_ACCOUNT=$(ARM_STORAGE_ACCOUNT)
	ARM_SUBSCRIPTION_ID=$(shell cat ~/.azure.json | jq -r .[0].id)
	ARM_TENNANT_ID=$(shell cat ~/.azure.json | jq -r .[0].tenantId)

.PHONY: az-principal
az-principal:
	az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }" > ~/.az_principal

.PHONY: clean
clean:
	@vagrant halt > /dev/null 2>&1
	@vagrant destroy -f ${FLAVOR} > /dev/null 2>&1 || /usr/bin/true
	@vagrant destroy -f redesign > /dev/null 2>&1 || /usr/bin/true
	@rm -f packer/virtualbox-centos*.box
	@rm -rf output-parallels-iso
	@rm -rf output-virtualbox
	@rm -rf packer-*-vbox
	@vagrant box remove ${FLAVOR} --provider=virtualbox || true
	@echo 'clean'

install:
	vagrant box add --force ${FLAVOR} packer/${PROVIDER}-${FLAVOR}.box
# ${IMAGE}

uninstall:
	vagrant box remove ${FLAVOR} --provider=${PROVIDER}


packer/${PROVIDER}-${FLAVOR}.box:
	packer validate packer-${FLAVOR}.json
	packer build -only=${PROVIDER}-iso packer-${FLAVOR}.json

.PHONY: test
test: check
	vagrant box list
	vagrant up --no-provision
	vagrant ssh -c 'ls /vagrant/Makefile'
	vagrant halt
	@echo test OK

debug:
	packer build -debug packer-${FLAVOR}.json

.PHONY: build
build: check
	packer build -only=${PROVIDER}-iso packer-${FLAVOR}.json

.PHONY: azurevm
