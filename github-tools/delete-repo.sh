#!/usr/bin/env bash
set -euo pipefail

echo "🗑️ Suppression d'un dépôt GitHub"
read -r -p "🔧 Nom du repo (ex: mon-repo ou wilonweb/mon-repo) : " INPUT

if [[ "$INPUT" == *"/"* ]]; then
  REPO="$INPUT"
else
  USERNAME="$(gh api user --jq .login)"
  REPO="$USERNAME/$INPUT"
fi

echo "⚠️ Tu vas supprimer : $REPO (irréversible)"
read -r -p "✋ Confirmer ? (o/n) : " CONFIRM
[[ "$CONFIRM" == "o" ]] || { echo "❌ Annulé."; exit 1; }

gh repo delete "$REPO" --confirm
