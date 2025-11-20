resource "google_compute_firewall" "ssl_allowed" {
  name    = "ssh-allowed"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
