variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "network_id" {
  description = "VPC Network ID"
  type        = string
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
}

variable "machine_type" {
  description = "Machine Type"
  type        = string
}

variable "node_count" {
  description = "Number of Nodes"
  type        = number
}