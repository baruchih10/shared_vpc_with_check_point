
## per_subnet_firewall/variables.tf

variable "host_project_id" {}
variable "security_project_id" {}
variable "app1_project_id" {}
variable "app2_project_id" {}
variable "onprem_peer_ip" {}
variable "vpn_shared_secret" {}
variable "region" {}
variable "zone" {}
variable "app1_subnet_cidr" {}
variable "app2_subnet_cidr" {}
variable "firewall_a_subnet_cidr" {}
variable "firewall_machine_type" {}
variable "interconnect_bandwidth" {}
variable "firewall_image" {}
variable "boot_disk_size" {}
variable "boot_disk_type" {}