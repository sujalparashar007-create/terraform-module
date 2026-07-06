output "network_id" {
  value = google_compute_network.vpc.id
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}