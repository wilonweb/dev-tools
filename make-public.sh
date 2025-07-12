#!/bin/bash

# 🔐 Vérifie que l'utilisateur est connecté à GitHub CLI
if ! gh auth status &>/dev/null; then
  echo "❌ Tu n'es pas connecté à GitHub CLI. Lance 'gh auth login' pour te connecter."
  exit 1
fi

# 📦 Demande le nom du dépôt à rendre public
read -p "Nom du dépôt (ex: mon-repo) : " REPO_NAME

# 👤 Récupère le nom d'utilisateur GitHub
USERNAME=$(gh api user | jq -r .login)

# 📡 Exécute la commande
echo "🚀 Passage en public de https://github.com/$USERNAME/$REPO_NAME..."
gh repo edit "$USERNAME/$REPO_NAME" --visibility public

if [ $? -eq 0 ]; then
  echo "✅ Le dépôt a bien été rendu public !"
else
  echo "❌ Une erreur s'est produite."
fi
