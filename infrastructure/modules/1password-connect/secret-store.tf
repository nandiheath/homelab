resource "kubectl_manifest" "secret-store" {
  yaml_body =<<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: onepassword
  labels:
    app.kubernetes.io/managed-by: terraform
spec:
  provider:
    onepassword:
      connectHost: http://onepassword-connect.1password.svc.cluster.local:8080
      vaults:
        HomeLab: 1
      auth:
        secretRef:
          connectTokenSecretRef:
            name: onepassword-connect-token
            namespace: external-secrets
            key: token
YAML

}
