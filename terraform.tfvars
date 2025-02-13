# Sample terraform.tfvars file
host_project_id     = "my-host-project"
security_project_id = "my-security-project"
app1_project_id     = "my-app1-project"
app2_project_id     = "my-app2-project"
onprem_peer_ip      = "203.0.113.1"
vpn_shared_secret   = "mysecurevpnpassword"
region              = "us-central1"
zone                = "us-central1-a"
interconnect_bandwidth  = "BPS_10G"
app1_subnet_cidr    = "10.10.0.0/24"
app2_subnet_cidr    = "10.20.0.0/24"
firewall_a_subnet_cidr = "10.30.0.0/24"
firewall_machine_type = "e2-standard-4"
firewall_image      = "check-point-firewall-image"
boot_disk_size      = 50
boot_disk_type      = "pd-ssd"

