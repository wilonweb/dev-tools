#!/bin/bash

echo "🗑️ Suppression d'un dépôt GitHub"

read -p "🔧 Nom du repo (ex: mon-repo ou wilonweb/mon-repo) : " INPUT

if [[ "$INPUT" == *"/"* ]]; then
  REPO="$INPUT"
else
  REPO="wilonweb/$INPUT"
fi

echo "⚠️ Tu t'apprêtes à supprimer le dépôt : $REPO"
echo "🚨 Cette action est irréversible !"

read -p "✋ Confirmer la suppression ? (o/n) : " CONFIRM

if [[ "$CONFIRM" != "o" ]]; then
  echo "❌ Annulé."
  exit 1
fi

gh repo delete "$REPO" --confirm
