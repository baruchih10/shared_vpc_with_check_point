# Per-Subnet Firewall Project

## Aim of this project
Shared VPC with Security Inspection, Cloud NAT, VPN, and Hybrid Connectivity.

## Description
This project demonstrates an enterprise network that includes:
- Shared VPC with Security Inspection
- Cloud NAT for internet access
- VPN for on-prem connectivity
- Hybrid connectivity using Interconnect
- Traffic inspection via Check Point Firewalls

### Terraform templates incorporate the following:

- Creates the Shared VPC and subnets
- Deploys Check Point Firewalls
- Implements Cloud NAT
- Configures VPN & Interconnect
- Enforces traffic inspection with custom routes

### Module Structure
```
/terraform
  ├── /modules
  │   ├── /per_subnet_firewall
  │   │   ├── main.tf
  │   │   ├── variables.tf
  │   │   ├── outputs.tf
  │   │   ├── README.md
  ├── main.tf
  ├── variables.tf
  ├── outputs.tf
```

## Per-Subnet Firewall Module
This Terraform module sets up a **Per-Subnet Security Architecture** in GCP. Each subnet routes traffic through its own dedicated firewall before reaching the internet.

### Features
- Creates **Shared VPC** with separate subnets.
- Deploys **Check Point Firewalls** in separate security projects.
- Implements **Cloud NAT** for outbound internet access.
- Establishes **VPN & Interconnect** for hybrid connectivity.
- Configures **custom routes** to enforce security.

### Comparison: Per-Subnet Firewall vs. Hub-and-Spoke Architecture
| Feature                     | Per-Subnet Firewall Architecture | Hub-and-Spoke Architecture |
|-----------------------------|---------------------------------|----------------------------|
| **Traffic Flow**            | Each subnet has a dedicated firewall | All traffic is routed through a central firewall in the hub |
| **Security Control**        | Fine-grained security per subnet | Centralized security policies for all spokes |
| **Scalability**             | Harder to scale due to multiple security instances | Easier to scale with additional spokes |
| **Cost**                    | Higher (multiple firewalls & NATs) | Lower (shared firewall & NAT) |
| **Operational Complexity**  | More complex due to distributed firewalls | Easier to manage from a central hub |
| **Failure Domain**          | Isolated failures per subnet | Single point of failure at the hub |
| **Performance**             | Lower latency per subnet but harder to manage at scale | Possible performance bottleneck at the hub |
| **Hybrid Connectivity**     | Each subnet can have its own VPN/Interconnect | Centralized VPN/Interconnect at the hub |

### Usage
```hcl
module "per_subnet_firewall" {
  source                  = "./modules/per_subnet_firewall"
  host_project_id         = "my-host-project"
  security_project_id     = "my-security-project"
  app1_project_id         = "my-app1-project"
  app2_project_id         = "my-app2-project"
  onprem_peer_ip          = "203.0.113.1"
  vpn_shared_secret       = "mysecret"
  region                  = "us-central1"
  zone                    = "us-central1-a"
  interconnect_bandwidth  = "BPS_10G"
  app1_subnet_cidr        = "10.10.0.0/24"
  app2_subnet_cidr        = "10.20.0.0/24"
  firewall_a_subnet_cidr  = "10.30.0.0/24"
  firewall_machine_type   = "e2-standard-4"
  firewall_image          = "check-point-firewall-image"
  boot_disk_size          = 50
  boot_disk_type          = "pd-ssd"
}
```

### Outputs
- `firewall_ips`: List of IPs for deployed firewalls.

### Deployment Instructions
1. **Initialize Terraform**
   ```bash
   terraform init
   ```
2. **Validate Configuration**
   ```bash
   terraform validate
   ```
3. **Plan the Deployment**
   ```bash
   terraform plan -var-file="terraform.tfvars"
   ```
4. **Apply the Configuration**
   ```bash
   terraform apply -var-file="terraform.tfvars" -auto-approve
   ```
5. **View Firewall IPs Output**
   ```bash
   terraform output firewall_ips
   ```
