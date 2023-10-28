locals {
  namespace = "argocd"
  argocd_repo = "https://github.com/nandiheath/homelab-argocd-infra"
  argocd_application_path = "singularity/base/"
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = local.namespace
  create_namespace = true
  version          = "5.46.8"

  values = [
    # `values.yaml` will be overwritten if the file exists at terragrunt
    file("${path.cwd}/values-default.yaml"),
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
