# ────────────────────────────────────────────────────────────────
# 📦 Fonctions Bash/Zsh pour outils perso (tools + github)
# 📁 À sourcer dans ~/.zshrc ou ~/.bashrc
# 🔁 Utiliser `source ~/.zshrc` ou `reload` après modif
# ────────────────────────────────────────────────────────────────

# 🔧 Menu TOOLS
function tools() {
  echo "🧰 Menu TOOLS"
  echo "1) Afficher l'arborescence (structure.txt)"
  echo "2) Lister les fichiers .sh (liste-sh.txt)"
  echo "3) Concaténer les .js avec titres (liste-js.txt)"
  echo "4) Concaténer les .sh avec titres (liste-sh-concat.txt)"
  echo "5) Concaténer les .md avec titres (liste-md.txt)"
  echo "6) Menu GitHub"
  echo "7) Quitter"
  echo -n "Ton choix : "
  read choice

  case $choice in
    1)
      echo "📁 Génération de structure.txt..."
      find . | awk -F/ '{ indent = ""; for(i=2;i<NF;i++) indent=indent"│   "; if(NF>1) print indent "├── " $NF; else print $0; }' > structure.txt
      echo "✅ Terminé"
      ;;
    2)
      echo "🔍 Liste des fichiers .sh..."
      find . -type f -name "*.sh" > liste-sh.txt
      echo "✅ Terminé"
      ;;
    3)
      echo "📜 Concaténation des fichiers .js..."
      > liste-js.txt
      find . -type f -name "*.js" | while read -r file; do
        echo "===== $file =====" >> liste-js.txt
        cat "$file" >> liste-js.txt
        echo -e "\n" >> liste-js.txt
      done
      echo "✅ Terminé"
      ;;
    4)
      echo "📜 Concaténation des fichiers .sh..."
      > liste-sh-concat.txt
      find . -type f -name "*.sh" | while read -r file; do
        echo "===== $file =====" >> liste-sh-concat.txt
        cat "$file" >> liste-sh-concat.txt
        echo -e "\n" >> liste-sh-concat.txt
      done
      echo "✅ Terminé"
      ;;
    5)
      echo "📘 Concaténation des fichiers .md..."
      > liste-md.txt
      find . -type f -name "*.md" | while read -r file; do
        echo "===== $file =====" >> liste-md.txt
        cat "$file" >> liste-md.txt
        echo -e "\n" >> liste-md.txt
      done
      echo "✅ Terminé"
      ;;
    6)
      github
      ;;
    7)
      echo "👋 Bye !"
      ;;
    *)
      echo "❌ Choix invalide"
      ;;
  esac
}

# 🧰 Menu GitHub
function github() {
  echo "🐙 Menu GitHub CLI"
  echo "1) Créer un repo"
  echo "2) Supprimer un repo"
  echo "3) Lister mes repos"
  echo "4) Passer un repo en public"
  echo "5) Tout passer en privé"
  echo "6) Changer visibilité d’un repo"
  echo "7) Quitter"
  echo -n "👉 Ton choix : "
  read choice

  case $choice in
    1) bash ~/Documents/VisualStudioCode/dev-tools/github-tools/create-repo.sh ;;
    2) bash ~/Documents/VisualStudioCode/dev-tools/github-tools/delete-repo.sh ;;
    3) bash ~/Documents/VisualStudioCode/dev-tools/github-tools/list-repo.sh ;;
    4) bash ~/Documents/VisualStudioCode/dev-tools/github-tools/make-public.sh ;;
    5) bash ~/Documents/VisualStudioCode/dev-tools/github-tools/private-all.sh ;;
    6) bash ~/Documents/VisualStudioCode/dev-tools/github-tools/togle-visibility.sh ;;
    7) echo "👋 À bientôt" ;;
    *) echo "❌ Choix invalide" ;;
  esac
}
