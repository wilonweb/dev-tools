#!/bin/bash

# Ce script rend tous tes repos en privé (⚠️ irréversible sauf manuellement)

echo "🔐 Début : rendre tous les dépôts privés..."
gh repo list $USER --limit 100 --json name,visibility --jq '.[] | select(.visibility == "public") | .name' |
while read repo; do
  echo "➡️  Repo : $repo → privé"
  gh repo edit "$USER/$repo" --visibility private
done
echo "✅ Tous les dépôts publics sont maintenant privés."
