module "network" {
  source = "./modules/network"

  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  region      = var.region
}

module "cloud_nat" {
  source = "./modules/cloud-nat"

  region     = var.region
  network_id = module.network.network_id
}


module "gke" {

  source = "./modules/gke"

  cluster_name = var.cluster_name

  region = var.region
  zone   = var.zone

  network_id = module.network.network_id

  subnet_name = module.network.subnet_name

  machine_type = var.machine_type

  node_count = var.node_count
}
module "bastion" {

  source = "./modules/bastion"

  zone = var.zone

  network_id = module.network.network_id

  subnet_name = module.network.subnet_name
}