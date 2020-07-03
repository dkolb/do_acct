terraform {
  backend "s3" {
    bucket                      = "dkub-tfstate"
    endpoint                    = "sfo2.digitaloceanspaces.com"
    region                      = "us-west-1"
    key                         = "dkolb/do-acct/terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

variable "do_token" {}
variable "spaces_access_id" {}
variable "spaces_secret_key" {}

provider "digitalocean" {
  version = "~> 1.20"
  token   = var.do_token

  spaces_access_id  = var.spaces_access_id
  spaces_secret_key = var.spaces_secret_key
}

provider "kubernetes" {
  version          = "~> 1.11"
  load_config_file = false
  host             = digitalocean_kubernetes_cluster.k8s.endpoint
  token            = digitalocean_kubernetes_cluster.k8s.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  version = "~> 1.2"
  kubernetes {
    load_config_file = false
    host             = digitalocean_kubernetes_cluster.k8s.endpoint
    token            = digitalocean_kubernetes_cluster.k8s.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
    )
  }
}
