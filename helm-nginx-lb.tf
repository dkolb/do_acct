resource helm_release "nginx_ingress" {
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.publishService.enabled"
    value = true
  }

  set {
    name  = "defaultBackend.enabled"
    value = true
  }

  values = [yamlencode({
    controller = {
      service = {
        annotations = {
          "external-dns.alpha.kubernetes.io/hostname" = "do.krinchan.com"
        }
      }
    }
  })]
}
