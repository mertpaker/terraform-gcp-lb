output "group1_region" {
  value = "${var.group1_region}"
}

output "group2_region" {
  value = "${var.group2_region}"
}

output "group3_region" {
  value = "${var.group3_region}"
}

output "load-balancer-ip" {
  value = "${module.gce-lb-https.external_ip}"
}

output "asset-url" {
  value = "https://${module.gce-lb-https.external_ip}/assets/gcp-logo.svg"
}