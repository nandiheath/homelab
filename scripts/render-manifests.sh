#!/bin/bash

RENDER_DIR="rendered"

dir_path=$(dirname "${BASH_SOURCE[0]}")


source "$dir_path/lib.sh"

charts=$(changed_charts)

for chart in $charts ; do
  output_path="$RENDER_DIR/$(echo "$chart" | cut -d'/' -f2)"
  mkdir -p "$output_path"
  kustomize build --enable-helm "$chart" | yq -s '"'"$output_path/"'" + (.kind | downcase) + "_" + .metadata.name'

done
