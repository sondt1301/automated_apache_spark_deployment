variable "project_id" {
    description = "GCP project ID"
    type = string
}

variable "region" {
    description = "GCP region"
    type = string
    default = "asia-southeast1"
}

variable "zone" {
    description = "GCP zone"
    type = string
    default = "asia-southeast1-a"
}

variable "credentials_file" {
    description = "Local path to the service account key"
    type = string
}

variable "instance_image" {
    description = "Instance image for VM"
    type = string
    default = "ubuntu-os-cloud/ubuntu-2204-lts"
}
