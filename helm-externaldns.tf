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

