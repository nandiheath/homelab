resource "kubernetes_manifest" "argocd_app" {
  # must be installed after ArgoCD is ready
  depends_on = [helm_release.argocd]
  manifest = yamldecode(<<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: singularity
  # You'll usually want to add your resources to the argocd namespace.
  namespace: argocd
  # Add this finalizer ONLY if you want these to cascade delete.
  finalizers:
    # The default behaviour is foreground cascading deletion
    - resources-finalizer.argocd.argoproj.io
    # Alternatively, you can use background cascading deletion
    # - resources-finalizer.argocd.argoproj.io/background
  # Add labels to your application object.
  labels:
    name: singularity
spec:
  # The project the application belongs to.
  project: default

  # Source of the application manifests
  source:
    repoURL: ${local.argocd_repo}  # Can point to either a Helm chart repo or a git repo.
    targetRevision: HEAD  # For Helm, this refers to the chart version.
    path: ${local.argocd_application_path}  # This has no meaning for Helm charts pulled directly from a Helm repo instead of git.

    # kustomize specific config
    kustomize: {}

  # Destination cluster and namespace to deploy the application
  destination:
    # cluster API URL
    server: https://kubernetes.default.svc
    # or cluster name
    # name: in-cluster
    # The namespace will only be set for namespace-scoped resources that have not set a value for .metadata.namespace
    namespace: argocd

  # Sync policy
  syncPolicy:
    automated: # automated sync by default retries failed attempts 5 times with following delays between attempts ( 5s, 10s, 20s, 40s, 80s ); retry controlled using `retry` field.
      prune: true # Specifies if resources should be pruned during auto-syncing ( false by default ).
      selfHeal: true # Specifies if partial app sync should be executed when resources are changed only in target Kubernetes cluster and no git change detected ( false by default ).
      allowEmpty: false # Allows deleting all application resources during automatic syncing ( false by default ).
    syncOptions:     # Sync options which modifies sync behavior
    - Validate=false # disables resource validation (equivalent to 'kubectl apply --validate=false') ( true by default ).
    - CreateNamespace=false # Namespace Auto-Creation ensures that namespace specified as the application destination exists in the destination cluster.
    - PrunePropagationPolicy=foreground # Supported policies are background, foreground and orphan.
    - PruneLast=true # Allow the ability for resource pruning to happen as a final, implicit wave of a sync operation
    - RespectIgnoreDifferences=true # When syncing changes, respect fields ignored by the ignoreDifferences configuration

    # The retry feature is available since v1.7
    retry:
      limit: 5 # number of failed sync attempt retries; unlimited number of attempts if less than 0
      backoff:
        duration: 5s # the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
        factor: 2 # a factor to multiply the base duration after each failed retry
        maxDuration: 3m # the maximum amount of time allowed for the backoff strategy

  # RevisionHistoryLimit limits the number of items kept in the application's revision history, which is used for
  # informational purposes as well as for rollbacks to previous versions. This should only be changed in exceptional
  # circumstances. Setting to zero will store no history. This will reduce storage used. Increasing will increase the
  # space used to store the history, so we do not recommend increasing it.
  revisionHistoryLimit: 10
YAML
  )
}
