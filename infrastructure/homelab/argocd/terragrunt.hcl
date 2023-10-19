
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/argocd"
}

inputs = {
  values = file("values.yaml")
}

dependencies {
  paths = ["../external-secrets", "../1password"]
}
