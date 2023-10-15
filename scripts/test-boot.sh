#!/bin/bash

if [[ $(multipass list | grep test-vm) ]];then
  echo "pruning previous multipass VM .."
  multipass delete test-vm -p
fi

# generate boot init
./scripts/boot-init 0

echo "+++ booting multipass VM to validate cloud-init scripts .."
# Test the generate user-data with multipass
multipass launch 22.04 --name test-vm --cloud-init /Volumes/system-boot/user-data
