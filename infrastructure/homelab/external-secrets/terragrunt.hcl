
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/external-secrets"
}

inputs = {
  api_token = file("${get_repo_root()}/credentials/1password/1password-token.txt")
}

