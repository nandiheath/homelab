# HomeLab

This is a hobby project aimed to setup a high available, and portable Kubernetes cluster, 

## Overview

Setting up Raspberry Pi is fun. Setting up a K3S cluster is fun. 
Setting up the IaC is fun.
But setting them all up is ... not fun.

This is a home-brew project aimed to break down all process into separate modules,
providing a simple enough yet self-explanatory procedure for each step.

Some Highlights:
- a shell script to set up the boot settings and k3s via cloud-init for the Raspberry Pi
- a shell script to download the kubeconfig
- terraform modules for setting up initial IaC configurations
  - remote vault with 1password connect
  - secret-store operator provided by external-secrets
  - ArgoCD setup to read private Github repository authenticated using Github App installation

![simple-infra.png](simple-infra.png)

## Getting Started

### Prerequisites

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Taskfile](https://taskfile.dev/installation/)

### Setting Up The Raspberry Pi 

- Download Ubuntu Server 22.04 LTS and burn it to SD card
- Run `./scripts/boot-init [id]` to configure the boot configure for RPi image, this includes
  - setup network configuration (modify as needed)
  - tune PoE+ fan speed
- Insert the SD Card to RPi and boot each node up.

### Install K3S with Ansible

- Configure the host information at `ansible/inventory.yaml` 
- Run `task install`
  - This will install the K3S cluster via Ansible 

## Debug

```bash
ssh nandi@node_ip

> journalctl -u k3s.service -f
```

## Operations

### Rotate Certs


