output "firewall_ips" {
  value = [
    google_compute_instance.firewall_a.network_interface[0].network_ip
  ]
}