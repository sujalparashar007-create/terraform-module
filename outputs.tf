output "network_id" {
  value = module.network.network_id
}

output "subnet_name" {
  value = module.network.subnet_name
}

output "router_name" {
  value = module.cloud_nat.router_name
}

output "nat_name" {
  value = module.cloud_nat.nat_name
}

output "cluster_name" {
  value = module.gke.cluster_name
}

output "cluster_endpoint" {
  value = module.gke.cluster_endpoint
}

output "gke_cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = module.gke.cluster_endpoint
}

output "bastion_ip" {
  value = module.bastion.bastion_ip
}
