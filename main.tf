terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.host_project_id
  region  = var.region
}

module "per_subnet_firewall" {
  source                  = "./modules/per_subnet_firewall"
  host_project_id         = var.host_project_id
  security_project_id     = var.security_project_id
  app1_project_id         = var.app1_project_id
  app2_project_id         = var.app2_project_id
  onprem_peer_ip          = var.onprem_peer_ip
  vpn_shared_secret       = var.vpn_shared_secret
  region                  = var.region
  zone                    = var.zone
  interconnect_bandwidth  = var.interconnect_bandwidth
  app1_subnet_cidr        = var.app1_subnet_cidr
  app2_subnet_cidr        = var.app2_subnet_cidr
  firewall_a_subnet_cidr  = var.firewall_a_subnet_cidr
  firewall_machine_type   = var.firewall_machine_type
  firewall_image          = var.firewall_image
  boot_disk_size          = var.boot_disk_size
  boot_disk_type          = var.boot_disk_type
}

output "firewall_ips" {
  description = "List of firewall IPs"
  value       = module.per_subnet_firewall.firewall_ips
}
