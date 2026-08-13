variable "project" {
  description = "Human-readable project label."
  type        = string
  default     = "education-lab"
}

variable "name" {
  description = "Generic VM hostname."
  type        = string
}

variable "node_name" {
  description = "Generic Proxmox node name."
  type        = string
}

variable "vm_id" {
  description = "VM identifier for this example instance."
  type        = number
}

variable "template_vm_id" {
  description = "Existing cloud-image template identifier."
  type        = number
}

variable "cpu_cores" {
  type    = number
  default = 2

  validation {
    condition     = var.cpu_cores >= 1 && var.cpu_cores <= 16
    error_message = "cpu_cores must be between 1 and 16."
  }
}

variable "memory_mb" {
  type    = number
  default = 4096
}

variable "disk_size_gb" {
  type    = number
  default = 32
}

variable "datastore_id" {
  type    = string
  default = "example-storage"
}

variable "network_bridge" {
  type    = string
  default = "vmbr-example"
}

variable "ipv4_cidr" {
  description = "Use a documentation address until deliberately adapted."
  type        = string
  default     = "192.0.2.20/24"
}

variable "ipv4_gateway" {
  type    = string
  default = "192.0.2.1"
}

variable "bootstrap_user" {
  type    = string
  default = "automation-example"
}

variable "ssh_public_key" {
  description = "Injected at runtime; never commit a real key."
  type        = string
  sensitive   = true
}
