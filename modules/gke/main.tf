resource "google_container_cluster" "private_gke" {
  name = var.cluster_name

  # Create a ZONAL cluster instead of a regional cluster.
  location = var.zone

  network    = var.network_id
  subnetwork = var.subnet_name

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  cluster_autoscaling {
    enabled = true

    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 20
    }

    resource_limits {
      resource_type = "memory"
      minimum       = 1
      maximum       = 80
    }

    auto_provisioning_defaults {
      disk_type    = "pd-standard"
      disk_size    = 30
      oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

      management {
        auto_repair  = true
        auto_upgrade = true
      }
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/24"
      display_name = "VPC Subnet"
    }
  }
}

resource "google_container_node_pool" "general" {
  name       = "general-pool"
  location   = var.zone
  cluster    = google_container_cluster.private_gke.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    machine_type = var.machine_type
    disk_type    = "pd-standard"
    disk_size_gb = 30

    service_account = "1084753313256-compute@developer.gserviceaccount.com"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

resource "google_container_node_pool" "spot" {
  name       = "spot-pool"
  location   = var.zone
  cluster    = google_container_cluster.private_gke.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    machine_type = var.machine_type
    disk_type    = "pd-standard"
    disk_size_gb = 30
    spot         = true

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      workload = "spot"
    }

    taint {
      key    = "spot"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name = "primary-node-pool"

  # Same zone as the cluster.
  location = var.zone
  cluster  = google_container_cluster.private_gke.name

  node_count = var.node_count

  node_config {
    machine_type = var.machine_type

    # Reduce disk quota usage.
    disk_type    = "pd-standard"
    disk_size_gb = 30

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
