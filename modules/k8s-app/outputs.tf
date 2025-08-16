output "ingress_hostname" {
  description = "Hostname of the ALB created for the ingress"
  value       = try(kubernetes_ingress_v1.weather_app.status[0].load_balancer[0].ingress[0].hostname, "ALB hostname not available yet")
}