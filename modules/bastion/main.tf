resource "google_compute_instance" "bastion" {

  name         = "gke-bastion"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnet_name

    access_config {}
  }

  tags = ["bastion"]
}