include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/proxmox-vm"
}

inputs = {
  name             = "k3s-example-01"
  node_name        = "pve-example-01"
  vm_id            = 120
  template_vm_id   = 9000
  cpu_cores        = 2
  memory_mb        = 4096
  disk_size_gb     = 32
  datastore_id     = "example-storage"
  network_bridge   = "vmbr-example"
  ipv4_cidr        = "192.0.2.20/24"
  ipv4_gateway     = "192.0.2.1"
  bootstrap_user   = "automation-example"
  ssh_public_key   = get_env("EXAMPLE_SSH_PUBLIC_KEY")
}
