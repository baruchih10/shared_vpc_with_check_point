
output "firewall_ips" {
  value = [
    google_compute_instance.firewall_a.network_interface[0].network_ip,
    google_compute_instance.firewall_b.network_interface[0].network_ip
  ]
}