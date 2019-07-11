provider "google" {
  region = "${var.group1_region}"
  version = "1.18.0"
}


module "gce-lb-https" {
  source            = "../modules/terraform-google-lb-http"
  name              = "${var.network_name}"
  target_tags       = ["${module.mig1.target_tags}", "${module.mig2.target_tags}", "${module.mig3.target_tags}"]
  firewall_networks = ["${google_compute_network.default.name}"]
  url_map           = "${google_compute_url_map.https-content.self_link}"
  create_url_map    = false
  ssl               = true
  private_key       = "${tls_private_key.example.private_key_pem}"
  certificate       = "${tls_self_signed_cert.example.cert_pem}"

  backends = {
    "0" = [
      {
        group = "${module.mig1.instance_group}"
      },
      {
        group = "${module.mig2.instance_group}"
      },
      {
        group = "${module.mig3.instance_group}"
      },
    ]

    "1" = [
      {
        group = "${module.mig1.instance_group}"
      },
    ]

    "2" = [
      {
        group = "${module.mig2.instance_group}"
      },
    ]

    "3" = [
      {
        group = "${module.mig3.instance_group}"
      },
    ]
  }

  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "/,${module.mig1.service_port_name},${module.mig1.service_port},10",

    "/,${module.mig1.service_port_name},${module.mig1.service_port},10",
    "/,${module.mig2.service_port_name},${module.mig2.service_port},10",
    "/,${module.mig3.service_port_name},${module.mig3.service_port},10",
  ]
}

resource "google_compute_url_map" "https-content" {
  // note that this is the name of the load balancer
  name            = "${var.network_name}"
  default_service = "${module.gce-lb-https.backend_services[0]}"

  host_rule = {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher = {
    name            = "allpaths"
    default_service = "${module.gce-lb-https.backend_services[0]}"

    path_rule {
      paths   = ["/group1", "/group1/*"]
      service = "${module.gce-lb-https.backend_services[1]}"
    }

    path_rule {
      paths   = ["/group2", "/group2/*"]
      service = "${module.gce-lb-https.backend_services[2]}"
    }

    path_rule {
      paths   = ["/group3", "/group3/*"]
      service = "${module.gce-lb-https.backend_services[3]}"
    }

    path_rule {
      paths   = ["/assets", "/assets/*"]
      service = "${google_compute_backend_bucket.assets.self_link}"
    }
  }
}




