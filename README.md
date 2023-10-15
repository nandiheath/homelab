# HomeLab


## Infrastructure

https://whimsical.com/homelab-network-topology-PQYpjZ9LF5J1nC2yxTocJc


## Installation

### OS

- https://www.raspberrypi.com/software/
- Download Ubuntu Server 22.04 LTS (64 Bit)

Once image is loaded to SD card, run the following script to setup cloud-init:

```bash
# setup master node 
./scripts/boot-init 0

# setup client node
./scripts/boot-init 1
```

This setup the bootstrap scripts for running a raspberry pi instance, and setup k3s on it.

### Network

K3S rely on IP, so we need to setup static DHCP leases for nodes

```bash

# Login to OpenWRT router:

# update host:
vi /etc/config/dhcp

# reload dnsmasq
/etc/init.d/dnsmasq restart

# unplug & plug the network cable
```







## Development

### Test `cloud-init` locally

Run [multipass](https://cloudinit.readthedocs.io/en/latest/howto/predeploy_testing.html#multipass) to validate the cloud-init.

```bash
./scripts/test-boot.sh
```

## Debug

```bash
ssh nandi@node_ip

> journalctl -u k3s.service -f
```

## Operations

### Rotate Certs


