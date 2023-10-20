#!/bin/bash

set -eou pipefail

source /dev/stdin <<< $(grep = config/config.ini)

echo "exporting kube-config from master [${master_ip}] to ${kubecfg}"
ssh "$user"@"$master_ip" -- sudo cat /etc/rancher/k3s/k3s.yaml >  "$kubecfg"

sed -i'' -e 's/127.0.0.1:6443/10.43.2.1:6443/g' "$kubecfg"
sed -i'' -e 's/127.0.0.1:6443/10.43.2.1:6443/g' "$kubecfg"

echo "done."
echo ""

echo "the kubeconfig is loaded to $kubecfg. If it is not the default kubeconfig path, run the following command:"
echo "> echo \"export KUBECONFIG=\\\"$kubecfg:$KUBECONFIG\\\"\"  > ~/.bash_profile "
