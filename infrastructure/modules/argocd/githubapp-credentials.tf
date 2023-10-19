resource "kubernetes_manifest" "github_app_credentials" {
  manifest = yamldecode(<<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: argocd-github-app
  namespace: ${local.namespace}
spec:
  secretStoreRef:
    kind: ClusterSecretStore
    name: onepassword
  target:
    creationPolicy: Owner
    # Specify a blueprint for the resulting Kind=Secret
    template:
      # https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-repo-creds-yaml/
      type: Opaque
      engineVersion: v2
      metadata:
        labels:
          argocd.argoproj.io/secret-type: repo-creds
      data:
        type: git
        url: https://github.com/nandiheath
  data:
    - secretKey: githubAppID
      remoteRef:
        key: github-app-credentials
        property: app-id
    - secretKey: githubAppInstallationID
      remoteRef:
        key: github-app-credentials
        property: installation-id
    - secretKey: githubAppPrivateKey
      remoteRef:
        key: github-app-credentials
        property: private-key
YAML
  )
}
