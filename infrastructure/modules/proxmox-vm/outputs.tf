output "vm_id" {
  description = "Identifier of the example VM."
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_name" {
  description = "Name of the example VM."
  value       = proxmox_virtual_environment_vm.this.name
}
