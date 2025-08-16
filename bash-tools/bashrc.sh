#!/usr/bin/env bash
# Fonctions Bash/Zsh pour outils perso (tools + github)
# A sourcer dans ~/.bashrc ou ~/.zshrc

# 👉 Strict mode seulement pour les shells non interactifs (évite "unbound variable")
case $- in
  *i*) ;;  # interactif: pas de set -euo pipefail
  *) set -o errexit -o nounset -o pipefail ;;
esac

# 👉 TOOLS_DIR: préfère la variable existante, sinon déduit le chemin du fichier courant
if [ -z "${TOOLS_DIR:-}" ]; then
  if [ -n "${BASH_SOURCE-}" ]; then           # bash (même si le fichier est sourcé)
    _src="${BASH_SOURCE[0]}"
  elif [ -n "${ZSH_VERSION-}" ]; then         # zsh: %N donne le nom du script sourcé
    _src="${(%):-%N}"
  else                                        # fallback (exécuté comme script)
    _src="$0"
  fi
  TOOLS_DIR="$(cd "$(dirname "$_src")/.." && pwd)"
  unset _src
fi
export TOOLS_DIR

# Reload pratique
command -v reload >/dev/null 2>&1 || alias reload='exec "$SHELL" -l'

# Pré-requis (soft warning)
command -v git >/devnull 2>&1 || echo "⚠️ git manquant"
command -v gh  >/dev/null 2>&1 || echo "⚠️ GitHub CLI (gh) manquant"

tools() {
  echo "🧰 Menu TOOLS"
  echo "1) Afficher l'arborescence (structure.txt)"
  echo "2) Lister les fichiers .sh (liste-sh.txt)"
  echo "3) Concaténer les .js avec titres (liste-js.txt)"
  echo "4) Concaténer les .sh avec titres (liste-sh-concat.txt)"
  echo "5) Concaténer les .md avec titres (liste-md.txt)"
  echo "6) Menu GitHub"
  echo "7) Quitter"
  read -r -p "Ton choix : " choice

  case "$choice" in
    1)
      echo "📁 Génération de structure.txt..."
      find . \( -path "./.git" -o -path "./node_modules" \) -prune -o -print \
      | awk -F/ '{ indent=""; for(i=2;i<NF;i++) indent=indent"│   "; if(NF>1) print indent "├── " $NF; else print $0; }' \
      > structure.txt
      echo "✅ Terminé"
      ;;
    2)
      echo "🔍 Liste des fichiers .sh..."
      find . \( -path "./.git" -o -path "./node_modules" \) -prune -o -type f -name "*.sh" -print > liste-sh.txt
      echo "✅ Terminé"
      ;;
    3)
      echo "📜 Concaténation des fichiers .js..."
      : > liste-js.txt
      find . \( -path "./.git" -o -path "./node_modules" \) -prune -o -type f -name "*.js" -print \
      | while read -r file; do
          printf "===== %s =====\n" "$file" >> liste-js.txt
          cat "$file" >> liste-js.txt
          printf "\n\n" >> liste-js.txt
        done
      echo "✅ Terminé"
      ;;
    4)
      echo "📜 Concaténation des fichiers .sh..."
      : > liste-sh-concat.txt
      find . \( -path "./.git" -o -path "./node_modules" \) -prune -o -type f -name "*.sh" -print \
      | while read -r file; do
          printf "===== %s =====\n" "$file" >> liste-sh-concat.txt
          cat "$file" >> liste-sh-concat.txt
          printf "\n\n" >> liste-sh-concat.txt
        done
      echo "✅ Terminé"
      ;;
    5)
      echo "📘 Concaténation des fichiers .md..."
      : > liste-md.txt
      find . \( -path "./.git" -o -path "./node_modules" \) -prune -o -type f -name "*.md" -print \
      | while read -r file; do
          printf "===== %s =====\n" "$file" >> liste-md.txt
          cat "$file" >> liste-md.txt
          printf "\n\n" >> liste-md.txt
        done
      echo "✅ Terminé"
      ;;
    6) github ;;
    7) echo "👋 Bye !" ;;
    *) echo "❌ Choix invalide" ;;
  esac
}

github() {
  echo "🐙 Menu GitHub CLI"
  echo "1) Créer un repo"
  echo "2) Supprimer un repo"
  echo "3) Lister mes repos"
  echo "4) Passer un repo en public"
  echo "5) Tout passer en privé"
  echo "6) Changer visibilité d’un repo"
  echo "7) Quitter"
  read -r -p "👉 Ton choix : " choice

  case "$choice" in
    1) bash "${TOOLS_DIR}/github-tools/create-repo.sh" ;;
    2) bash "${TOOLS_DIR}/github-tools/delete-repo.sh" ;;
    3) bash "${TOOLS_DIR}/github-tools/list-repo.sh" ;;
    4) bash "${TOOLS_DIR}/github-tools/make-public.sh" ;;
    5) bash "${TOOLS_DIR}/github-tools/private-all.sh" ;;
    6) bash "${TOOLS_DIR}/github-tools/toggle-visibility.sh" ;;
    7) echo "👋 À bientôt" ;;
    *) echo "❌ Choix invalide" ;;
  esac
}
