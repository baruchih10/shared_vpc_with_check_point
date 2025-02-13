variable "host_project_id" {
  description = "The GCP project ID hosting the Shared VPC"
  type        = string
}

variable "security_project_id" {
  description = "The GCP project ID for the security VPC"
  type        = string
}

variable "app1_project_id" {
  description = "The GCP project ID for application 1"
  type        = string
}

variable "app2_project_id" {
  description = "The GCP project ID for application 2"
  type        = string
}

variable "onprem_peer_ip" {
  description = "The on-premises peer IP for VPN connectivity"
  type        = string
}

variable "vpn_shared_secret" {
  description = "Shared secret for VPN authentication"
  type        = string
}

variable "region" {
  description = "The default region for resources"
  type        = string
}

variable "zone" {
  description = "The zone where compute resources are deployed"
  type        = string
}

variable "interconnect_bandwidth" {
  description = "The bandwidth for the interconnect"
  type        = string
}

variable "app1_subnet_cidr" {
  description = "CIDR block for App1 subnet"
  type        = string
}

variable "app2_subnet_cidr" {
  description = "CIDR block for App2 subnet"
  type        = string
}

variable "firewall_a_subnet_cidr" {
  description = "CIDR block for Firewall A subnet"
  type        = string
}

variable "firewall_machine_type" {
  description = "The machine type for the firewall instances"
  type        = string
}

variable "firewall_image" {
  description = "The image to use for the firewall instances"
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the boot disk for the firewall instances"
  type        = number
}

variable "boot_disk_type" {
  description = "The type of the boot disk for the firewall instances"
  type        = string
}
