resource "google_container_cluster" "private_gke" {

  name     = var.cluster_name
  location = var.region

  network    = var.network_id
  subnetwork = var.subnet_name

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {

    enable_private_nodes = true

    enable_private_endpoint = false

    master_ipv4_cidr_block = "172.16.0.0/28"
  }
}


resource "google_container_node_pool" "primary_nodes" {

  name = "primary-node-pool"

  location = var.region

  cluster = google_container_cluster.private_gke.name

  node_count = var.node_count

  node_config {

    machine_type = var.machine_type
    disk_size_gb=30

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {

    auto_repair  = true

    auto_upgrade = true
  }
}