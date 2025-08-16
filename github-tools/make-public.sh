#!/usr/bin/env bash
set -euo pipefail

echo "🔓 Passage d’un dépôt GitHub en public"
read -r -p "Nom du dépôt (ex: mon-repo) : " repo
USERNAME="${USERNAME:-$(gh api user --jq .login)}"

echo "🚀 $USERNAME/$repo → public…"
gh repo edit "$USERNAME/$repo" --visibility public --accept-visibility-change-consequences \
  && echo "✅ OK" || echo "❌ Erreur"
