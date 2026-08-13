locals {
  project = "education-lab"
}

remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "${get_repo_root()}/.terraform-state/${path_relative_to_include()}.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "proxmox" {
      endpoint = "https://pve.example.com:8006/"
      insecure = false
    }
  EOF
}

inputs = {
  project = local.project
}
