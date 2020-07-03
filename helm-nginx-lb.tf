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


resource helm_release "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "test_site" {
  name       = "joomla"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "joomla"

  values = [yamlencode({
    joomlaPassword = "initalpassword"
    persistence = {
      enabled = false
    }
    mariadb = {
      master = {
        persistence = {
          enabled = false
        }
      }
    }
    service = {
      type = "ClusterIP"
    }
    ingress = {
      hosts = [
        { name = "www.do.krinchan.com" }
      ]
      enabled     = true
      certManager = true
      tls = [
        {
          hosts      = ["www.do.krinchan.com"]
          secretName = "joomla.local-tls"
        }
      ]
      annotations = {
        "kubernetes.io/ingress.class"    = "nginx"
        "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      }
    }
  })]
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

resource helm_release "external_dns" {
  name       = "dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  values = [yamlencode({
    "rbac" = {
      "create" = true
    },
    "provider" = "digitalocean",
    "digitalocean" = {
      "apiToken" = var.do_token
    },
    "interval"     = "5m"
    "policy"       = "sync",
    "domainFilter" = ["do.krinchan.com"]
  })]
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
