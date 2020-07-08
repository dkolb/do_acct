resource "helm_release" "test_site" {
  # Disable for now. Mostly here for reference.
  count      = 0
  name       = "joomla"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "joomla"

  values = [yamlencode({
    joomlaPassword = var.initial_password
    joomlaUsername = var.initial_user
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
          secretName = "joomla-tls"
        }
      ]
      annotations = {
        "kubernetes.io/ingress.class"    = "nginx"
        "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      }
    }
  })]
}
