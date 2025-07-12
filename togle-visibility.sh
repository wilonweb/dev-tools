#!/bin/bash

echo "🔁 Changement de visibilité d'un dépôt GitHub"

read -p "🔧 Nom du repo (ex: wilonweb/mon-repo) : " REPO
read -p "🎯 Nouvelle visibilité (public/private) : " VISIBILITY

if [[ "$VISIBILITY" != "public" && "$VISIBILITY" != "private" ]]; then
  echo "❌ Visibilité invalide. Choisis 'public' ou 'private'."
  exit 1
fi

echo "⚠️ Tu vas modifier la visibilité du dépôt : $REPO → $VISIBILITY"
read -p "✅ Confirmer ? (o/n) : " CONFIRM

if [[ "$CONFIRM" != "o" ]]; then
  echo "❌ Opération annulée."
  exit 1
fi

gh repo edit "$REPO" --visibility "$VISIBILITY" --accept-visibility-change-consequences

if [ $? -eq 0 ]; then
  echo "✅ Visibilité mise à jour avec succès pour $REPO"
else
  echo "❌ Échec de la mise à jour. Vérifie le nom du repo et ton accès."
fi
