locals {
  nfs_helm_options = {
    "persistence" = {
      "enabled"      = "true"
      "size"         = "100Gi"
      "storageClass" = "do-block-storage"
    }
  }
}

resource "helm_release" "nfs-shares" {
  name       = "nfs-server-provisioner"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  chart      = "nfs-server-provisioner"

  atomic            = true
  cleanup_on_fail   = true
  dependency_update = true
  timeout           = 0

  values = [yamlencode(local.nfs_helm_options)]
}
