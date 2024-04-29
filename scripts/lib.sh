#!/bin/bash

function changed_files() {
  local dir="$1"
  git diff --name-only origin/main | grep "$dir/" | cut -d'/' -f1-3 | uniq
}
