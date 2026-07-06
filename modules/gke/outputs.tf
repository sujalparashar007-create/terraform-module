output "cluster_name" {
  value = google_container_cluster.private_gke.name
}

output "cluster_endpoint" {
  value = google_container_cluster.private_gke.endpoint
}