resource "google_compute_network" "default" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "group1" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.126.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.group1_region}"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "group2" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.group2_region}"
  private_ip_google_access = true
}
