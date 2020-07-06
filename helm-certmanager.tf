resource helm_release "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubernetes_secret" "cert_manager_dns_challenge" {
  metadata {
    name = "certmanager-dns-challenge"
  }

  data = {
    access-token = var.do_token
  }

  type = "Opaque"
}

resource null_resource "custom_issuer" {
  triggers = {
    resource_yaml = file("${path.module}/resources/issuer.yaml")
  }

  provisioner "local-exec" {
    command = "kubectl apply -f resources/issuer.yaml"
  }

  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret.cert_manager_dns_challenge,
  ]
}
