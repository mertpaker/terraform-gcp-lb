output "load-balancer-ip" {
  value = "${module.gce-lb-fr.external_ip}"
}