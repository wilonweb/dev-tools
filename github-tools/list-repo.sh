#!/bin/bash

# Nom de ton utilisateur GitHub
USERNAME="wilonweb"

echo "🔍 Quel type de dépôts veux-tu afficher ?"
echo "1) Tous les dépôts"
echo "2) Dépôts publics"
echo "3) Dépôts privés"
echo "4) Dépôts template (modèles)"  # ✅ Ajout ici
read -p "#? " choice

case $choice in
  1)
    echo "📦 Tous les dépôts :"
    gh repo list "$USERNAME" --limit 100
    ;;
  2)
    echo "🌐 Dépôts publics :"
    gh repo list "$USERNAME" --visibility public --limit 100
    ;;
  3)
    echo "🔐 Dépôts privés :"
    gh repo list "$USERNAME" --visibility private --limit 100
    ;;
  4)
    echo "📁 Dépôts template (modèles) :"
    gh repo list "$USERNAME" --source --json name,isTemplate,visibility \
      -q '.[] | select(.isTemplate==true) | "\(.visibility | ascii_upcase) - \(.name)"'
    ;;
  *)
    echo "❌ Choix invalide. Veuillez entrer un chiffre entre 1 et 4."
    ;;
esac
