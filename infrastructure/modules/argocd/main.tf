locals {
  namespace = "argocd"
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = local.namespace
  create_namespace = true
  version          = "5.46.8"

  values = [
    file("values.yaml"),
    var.values
  ]
}


#resource "helm_release" "argocd_app" {
#  chart = ""
#  name  = ""
#
#  depends_on = [
#    helm_release.argocd
#  ]
#}
