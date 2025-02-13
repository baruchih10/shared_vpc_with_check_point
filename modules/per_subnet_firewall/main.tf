## per_subnet_firewall/main.tf

# Define the Shared VPC in the Host Project
resource "google_compute_network" "shared_vpc" {
  name                    = "corp-vpc"
  auto_create_subnetworks = false
  project                 = var.host_project_id
}

resource "google_compute_subnetwork" "app1_subnet" {
  name          = "subnet-a"
  network       = google_compute_network.shared_vpc.id
  ip_cidr_range = var.app1_subnet_cidr
  region        = var.region
  project       = var.host_project_id
}

resource "google_compute_subnetwork" "app2_subnet" {
  name          = "subnet-b"
  network       = google_compute_network.shared_vpc.id
  ip_cidr_range = var.app2_subnet_cidr
  region        = var.region
  project       = var.host_project_id
}

# Create Security VPCs and Check Point Firewalls
resource "google_compute_network" "security_vpc_a" {
  name                    = "security-vpc-a"
  auto_create_subnetworks = false
  project                 = var.security_project_id
}

resource "google_compute_subnetwork" "firewall_a_subnet" {
  name          = "fw-a-subnet"
  network       = google_compute_network.security_vpc_a.id
  ip_cidr_range = var.firewall_a_subnet_cidr
  region        = var.region
  project       = var.security_project_id
}

resource "google_compute_instance" "firewall_a" {
  name         = "firewall-a"
  machine_type = var.firewall_machine_type
  zone         = var.zone
  project      = var.security_project_id

  network_interface {
    subnetwork = google_compute_subnetwork.firewall_a_subnet.id
    access_config {}
  }

  boot_disk {
    initialize_params {
      image = var.firewall_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }
}

# Set Up VPC Peering (Shared VPC ↔ Security VPC)
resource "google_compute_network_peering" "shared_to_security_a" {
  name                  = "shared-to-security-a"
  network               = google_compute_network.shared_vpc.id
  peer_network          = google_compute_network.security_vpc_a.id
}

# Create Routes to Enforce Traffic Inspection
resource "google_compute_route" "route_app1_fw_a" {
  name        = "route-app1-to-fw-a"
  network     = google_compute_network.shared_vpc.id
  dest_range  = "0.0.0.0/0"
  next_hop_ip = google_compute_instance.firewall_a.network_interface[0].network_ip
  priority    = 100
}

# Deploy Cloud NAT to Enable Internet Access
resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.security_vpc_a.id
  region  = var.region
  project = var.security_project_id
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-gateway"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  project                            = var.security_project_id
}

# Create VPN for On-Prem Connectivity
resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = "vpn-gateway"
  network = google_compute_network.shared_vpc.id
  region  = var.region
  project = var.security_project_id
}

resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name                    = "vpn-tunnel"
  vpn_gateway             = google_compute_vpn_gateway.vpn_gateway.id
  peer_ip                 = var.onprem_peer_ip
  shared_secret           = var.vpn_shared_secret
  ike_version             = 2
  target_vpn_gateway      = google_compute_vpn_gateway.vpn_gateway.id
  project                 = var.security_project_id
}

# Create Interconnect for Hybrid Cloud Connectivity
resource "google_compute_interconnect_attachment" "interconnect" {
  name       = "corp-interconnect"
  region     = var.region
  project    = var.host_project_id
  bandwidth  = var.interconnect_bandwidth
  type       = "DEDICATED"
  router     = google_compute_router.nat_router.id
}


## per_subnet_firewall/outputs.tf

output "firewall_ips" {
  value = [
    google_compute_instance.firewall_a.network_interface[0].network_ip
  ]
}
