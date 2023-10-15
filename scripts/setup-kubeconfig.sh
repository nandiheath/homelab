#!/bin/bash

source /dev/stdin <<< $(grep = config/config.ini)

echo "exporting kube-config from master [${master_ip}] to ${kubecfg}"
ssh "$user"@"$master_ip" -- sudo cat /etc/rancher/k3s/k3s.yaml >  "$kubecfg"

sed -i'' -e 's/127.0.0.1:6443/10.43.2.1:6443/g' "$kubecfg"
sed -i'' -e 's/127.0.0.1:6443/10.43.2.1:6443/g' "$kubecfg"

echo "done."
echo ""
