#!/bin/bash

echo "🔓 Passage d’un dépôt GitHub en public"
read -p "Nom du dépôt (ex: mon-repo) : " repo

# Ajoute ton nom d'utilisateur GitHub ici si absent
username="wilonweb"

echo "🚀 Passage en public de https://github.com/$username/$repo..."

gh repo edit "$username/$repo" \
  --visibility public \
  --accept-visibility-change-consequences && \
  echo "✅ Le dépôt est maintenant public." || \
  echo "❌ Une erreur s'est produite."
