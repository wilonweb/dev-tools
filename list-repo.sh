#!/bin/bash

# Vérifie si gh CLI est disponible
if ! command -v gh &> /dev/null; then
  echo "❌ GitHub CLI (gh) non trouvé. Installe-le ici : https://cli.github.com/"
  exit 1
fi

# Sélection du type
echo "🔍 Quel type de dépôts veux-tu afficher ?"
select TYPE in "all" "public" "private"; do
  case $TYPE in
    all|public|private)
      break
      ;;
    *)
      echo "❌ Choix invalide. Réessaie."
      ;;
  esac
done

# Lister les repos
echo "📦 Dépôts $TYPE :"
gh repo list --visibility "$TYPE" --limit 100 --json name,visibility,description -q '.[] | "\(.visibility) - \(.name): \(.description // "Aucune description")"'
