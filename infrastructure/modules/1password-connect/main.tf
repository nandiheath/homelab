resource "helm_release" "onepassword_connect" {
  name             = "1password"
  repository       = "https://1password.github.io/connect-helm-charts"
  chart            = "connect"
  namespace        = "1password"
  create_namespace = true
  version          = "1.14.0"

  values = [
    file("${path.cwd}/values.yaml")
  ]

  # NOTE: This secret value must be base64 encoded after it becomes the OP_SESSION env var in the Connect Server Deployment, that means double base64 encoded here. (Or single w/ stringData.)
  set {
    name  = "connect.credentials_base64"
    value = sensitive(var.credentials)
  }
}
