output "master_ip" {
  value = google_compute_instance.master.network_interface[0].network_ip
}

output "worker_ips" {
  value = google_compute_instance.workers[*].network_interface[0].network_ip
}

output "edge_public_ip" {
  value = google_compute_instance.edge.network_interface[0].access_config[0].nat_ip
}

output "storage_ip" {
  value = google_compute_instance.storage.network_interface[0].network_ip
}
