
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/1password-connect"
}

inputs = {
  credentials = filebase64("${get_repo_root()}/credentials/1password/1password-credentials.json")
}

dependencies {
  paths = ["../external-secrets"]
}
