#!/bin/bash

# ───────────────────────────────────────────────
# 📁 Menu GitHub CLI : github()
# 📌 Permet de lancer des actions GitHub depuis un menu
# ───────────────────────────────────────────────

function github() {
  echo "🧰 Menu GitHub"
  echo "1) Créer un repo"
  echo "2) Supprimer un repo"
  echo "3) Lister mes repos"
  echo "4) Passer un repo en public"
  echo "5) Tout passer en privé"
  echo "6) Changer visibilité d’un repo"
  echo "7) Quitter"ls
  read -p "Ton choix : " choice

  case $choice in
    1) bash github-tools/create-repo.sh ;;
    2) bash github-tools/delete-repo.sh ;;
    3) bash github-tools/list-repo.sh ;;
    4) bash github-tools/make-public.sh ;;
    5) bash github-tools/private-all.sh ;;
    6) bash github-tools/togle-visibility.sh ;;
    7) echo "👋 À bientôt" ;;
    *) echo "❌ Choix invalide" ;;
  esac
}
