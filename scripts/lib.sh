#!/bin/bash

function changed_charts() {
  git diff --name-only main.. | grep "charts/" | cut -d'/' -f1-2 | uniq
}