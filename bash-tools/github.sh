#!/bin/bash
# ───────────────────────────────────────────────
# 📁 Menu GitHub CLI : github()
# 📌 Permet de lancer des actions GitHub depuis un menu
# ───────────────────────────────────────────────

set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

github() {
  echo "🧰 Menu GitHub"
  echo "1) Créer un repo"
  echo "2) Supprimer un repo"
  echo "3) Lister mes repos"
  echo "4) Passer un repo en public"
  echo "5) Tout passer en privé"
  echo "6) Changer visibilité d’un repo"
  echo "7) Quitter"
  read -r -p "Ton choix : " choice

  case "$choice" in
    1) bash "$TOOLS_DIR/github-tools/create-repo.sh" ;;
    2) bash "$TOOLS_DIR/github-tools/delete-repo.sh" ;;
    3) bash "$TOOLS_DIR/github-tools/list-repo.sh" ;;
    4) bash "$TOOLS_DIR/github-tools/make-public.sh" ;;
    5) bash "$TOOLS_DIR/github-tools/private-all.sh" ;;
    6) bash "$TOOLS_DIR/github-tools/toggle-visibility.sh" ;;
    7) echo "👋 À bientôt" ;;
    *) echo "❌ Choix invalide" ;;
  esac
}
