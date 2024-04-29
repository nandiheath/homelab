#!/bin/bash

set -oeu pipefail

RENDER_DIR="rendered"

dir_path=$(dirname "${BASH_SOURCE[0]}")


source "$dir_path/lib.sh"

changed_manifests=$(changed_files "manifests")

for manifests in $changed_manifests ; do
  echo "detected file changes in $manifests. rendering the raw manifests"
  output_path="$RENDER_DIR/$(echo "$manifests" | cut -d'/' -f2-3)"
  mkdir -p "$output_path"
  set +x
  kustomize build --enable-helm "$manifests" | yq -s '"'"$output_path/"'" + (.kind | downcase) + "_" + (.metadata.name | sub("\.","-"))'

  mv "$output_path/namespace"* "$RENDER_DIR/namespaces/"
done
