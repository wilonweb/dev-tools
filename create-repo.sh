#!/bin/bash

echo "🚀 Création d’un nouveau dépôt GitHub"

# Demande le nom du repo (nom du dossier courant par défaut)
default_name=$(basename "$PWD")
read -p "📝 Nom du dépôt [$default_name] : " repo_name
repo_name=${repo_name:-$default_name}

# Demande une description
read -p "📄 Description du dépôt : " description

# Demande la visibilité
echo "🔐 Visibilité :"
select visibility in "public" "private"; do
  if [[ "$visibility" == "public" || "$visibility" == "private" ]]; then
    break
  else
    echo "❌ Choix invalide. Réessaie."
  fi
done

# Crée le repo GitHub
echo "🔧 Création du dépôt distant sur GitHub..."
gh repo create "$repo_name" --"$visibility" --description "$description" --source=. --remote=origin --push

if [ $? -eq 0 ]; then
  echo "✅ Dépôt '$repo_name' créé avec succès et lié à ton dossier local."
else
  echo "❌ Échec de la création du dépôt."
fi
