resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = "k8s-cluster"
  region  = "nyc3"
  version = "1.18.3-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}
