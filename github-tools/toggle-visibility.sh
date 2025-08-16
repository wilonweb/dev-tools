#!/usr/bin/env bash
set -euo pipefail

read -r -p "🔧 Repo (ex: wilonweb/mon-repo ou mon-repo) : " REPO
read -r -p "🎯 Nouvelle visibilité (public/private) : " VISIBILITY

[[ "$VISIBILITY" == "public" || "$VISIBILITY" == "private" ]] || { echo "❌ Visibilité invalide."; exit 1; }

if [[ "$REPO" != */* ]]; then
  USERNAME="${USERNAME:-$(gh api user --jq .login)}"
  REPO="$USERNAME/$REPO"
fi

echo "⚠️ $REPO → $VISIBILITY"
read -r -p "Confirmer ? (o/n) : " CONFIRM
[[ "$CONFIRM" == "o" ]] || { echo "❌ Annulé."; exit 1; }

gh repo edit "$REPO" --visibility "$VISIBILITY" --accept-visibility-change-consequences \
  && echo "✅ OK" || echo "❌ Échec"
