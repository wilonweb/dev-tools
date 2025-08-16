#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Création d’un nouveau dépôt GitHub"

default_name="$(basename "$PWD")"
read -r -p "📝 Nom du dépôt [$default_name] : " repo_name
repo_name=${repo_name:-$default_name}

read -r -p "📄 Description du dépôt : " description

echo "🔐 Visibilité :"
select visibility in "public" "private"; do
  [[ "$visibility" == "public" || "$visibility" == "private" ]] && break
  echo "❌ Choix invalide."
done

# Init local si besoin
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git init
fi
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  git add -A
  git commit -m "chore: initial commit"
fi

# Crée distante (sans casser si origin existe déjà)
if git remote get-url origin >/dev/null 2>&1; then
  echo "ℹ️  Remote 'origin' existe déjà, je pousse simplement."
  gh repo create "$repo_name" --"$visibility" --description "$description" --source=. --push || true
else
  gh repo create "$repo_name" --"$visibility" --description "$description" --source=. --remote=origin --push
fi

echo "✅ Dépôt '$repo_name' prêt."
