VAGRANT_DEFAULT_PROVIDER=virtualbox
DOWNLOADS=/tmp/
M=6

help:
	@echo 'available make targets:'
	@grep PHONY: Makefile | cut -d: -f2 | sed '1d;s/^/make/'

.PHONY: prepare    # install dependencies
prepare:
	./prepare -v

roles: prepare

.PHONY: packer     # packer build
packer:
	packer build packer-centos${M}.json

packer/virtualbox-centos${M}.box: packer

box:
	vagrant box add --force --name=redesign/centos${M} packer/virtualbox-centos${M}.box
	vagrant up --no-provision centos${M}
	vagrant ssh

.PHONY: up         # vagrant up, in an idempotent way
up: roles
	vagrant up --no-provision centos${M}
	vagrant provision centos${M}

.PHONY: clean      # start over again
clean:
	vagrant destroy -f
	rm -rf output-virtualbox-iso
	rm -f packer/virtualbox-centos${M}.box
	vagrant box remove centos${M} || true
