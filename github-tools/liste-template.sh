#!/usr/bin/env bash
set -euo pipefail
USERNAME="${USERNAME:-wilonweb}"
gh repo list "$USERNAME" --limit 200 --json name,isTemplate,visibility \
  --jq '.[] | select(.isTemplate==true) | "\(.visibility | ascii_upcase) - \(.name)"'
