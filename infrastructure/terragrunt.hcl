locals {
  kubeconfig = "~/.kube/homelab.config"
  kubeconfig_context = "homelab"
}

generate "version" {
  path = "version.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOT
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

EOT
}

generate "k8s" {
  path = "provider-k8s.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOT
provider "kubernetes" {
  config_path    = "${local.kubeconfig}"
  config_context = "${local.kubeconfig_context}"
}

provider "kubectl" {
  config_path    = "${local.kubeconfig}"
  config_context = "${local.kubeconfig_context}"
}
EOT
}

generate "helm" {
  path = "provider-helm.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOT
provider "helm" {
  kubernetes {
    config_path    = "${local.kubeconfig}"
    config_context = "${local.kubeconfig_context}"
  }
}
EOT
}

remote_state {
  backend = "local"
  config = {
    path = "${get_parent_terragrunt_dir()}/${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
}
