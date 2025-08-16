#!/usr/bin/env bash
set -euo pipefail

USERNAME="${USERNAME:-$(gh api user --jq .login)}"

echo "⚠️ Tu vas rendre PRIVÉS tous les repos PUBLICS de $USERNAME"
read -r -p "Confirmer ? (tape: OUI) : " ok
[[ "$ok" == "OUI" ]] || { echo "❌ Annulé."; exit 1; }

gh repo list "$USERNAME" --limit 200 --json name,visibility --jq '.[] | select(.visibility=="public") | .name' \
| while read -r repo; do
    echo "➡️  $repo → private"
    gh repo edit "$USERNAME/$repo" --visibility private
  done

echo "✅ Terminé."
