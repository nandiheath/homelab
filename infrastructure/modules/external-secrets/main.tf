resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
  version          = "0.9.6"

}

locals {
  values = {
    token_secret = {
      api_token = var.api_token
    }
  }
}

resource "kubernetes_secret" "token" {
  metadata {
    name = "onepassword-connect-token"
    namespace = "external-secrets"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"

  data = {
    token = chomp(var.api_token)
  }
}

