# Define provider
terraform {
	required_providers {
		google = {
			source  = "hashicorp/google"
      		version = "~> 5.0"
    	}
  	}
}

# Define project details
provider "google" {
	project     = var.project_id
  	region      = var.region
  	zone        = var.zone
  	credentials = file(var.credentials_file)
}

# Define network based on GCP structure
# VPC
resource "google_compute_network" "vpc_network" {
	name = "spark-vpc"
}

# Sub-network
resource "google_compute_subnetwork" "subnet" {
	name          = "spark-subnet"
  	region        = var.region
  	network       = google_compute_network.vpc_network.id
  	ip_cidr_range = "10.0.0.0/16"
}

# Master node
resource "google_compute_instance" "master" {
	name         = "spark-master"
	machine_type = "e2-medium"
  	zone         = var.zone
  	boot_disk {
    	initialize_params {
      		image = var.instance_image
      		size  = 20
    	}
  	}
  	network_interface {
    	network    = google_compute_network.vpc_network.id
    	subnetwork = google_compute_subnetwork.subnet.id
  	}
  	metadata = {
    	ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  	}
}

# Worker nodes
resource "google_compute_instance" "workers" {
  	count        = 2
  	name         = "spark-worker-${count.index}"
  	machine_type = "e2-medium"
  	zone         = var.zone
  	boot_disk {
    	initialize_params {
      		image = var.instance_image
      		size  = 20
    	}
  	}
  	network_interface {
    	network    = google_compute_network.vpc_network.id
    	subnetwork = google_compute_subnetwork.subnet.id
  	}
	metadata = {
    	ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  	}
}

# Edge node
resource "google_compute_instance" "edge" {
  	name         = "edge-node"
  	machine_type = "e2-small"
  	zone         = var.zone
  	boot_disk {
    	initialize_params {
      		image = var.instance_image
      		size  = 10
    	}
  	}
  	network_interface {
    	network    = google_compute_network.vpc_network.id
    	subnetwork = google_compute_subnetwork.subnet.id
    	access_config {}
  	}
	metadata = {
    	ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  	}
}

# Storage node
resource "google_compute_instance" "storage" {
  	name         = "storage-node"
  	machine_type = "e2-medium"
  	zone         = var.zone
  	boot_disk {
    	initialize_params {
      		image = var.instance_image
      		size  = 50
    	}
  	}
  	network_interface {
    	network    = google_compute_network.vpc_network.id
    	subnetwork = google_compute_subnetwork.subnet.id
  	}
	metadata = {
    	ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  	}
}