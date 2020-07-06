resource helm_release "nginx_ingress" {
  name       = "ingress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  # values = [yamlencode({
  #   "service" = {
  #     "annotations" = {
  #       "external-dns.alpha.kubernetes.io/hostname" = "www.do.krinchan.com"
  #       "cert-manager.io/cluster-issuer"            = "cert-manager"
  #     }
  #   }
  # })]
}
