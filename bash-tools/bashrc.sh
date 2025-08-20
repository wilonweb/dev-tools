# ────────────────────────────────────────────────────────────────
# 📦 Fonctions Bash/Zsh pour outils perso (tools + github)
# 📁 À sourcer dans ~/.zshrc ou ~/.bashrc
# 🔁 Utiliser `source ~/.zshrc` ou `reload` après modif
# ────────────────────────────────────────────────────────────────

# 🔧 Helper : concaténer des fichiers correspondant à plusieurs motifs
# Usage: concat_files "sortie.txt" "*.js" "*.py" "Dockerfile"
function concat_files() {
  local outfile="$1"; shift
  : > "$outfile"  # vide/crée le fichier de sortie

  # Assoc array pour éviter les doublons si un fichier matche plusieurs motifs
  # (nécessite bash >= 4 ; sous zsh, ça passe aussi via emulate bash)
  declare -A seen

  # Parcourt chaque motif et ajoute les fichiers trouvés
  for pattern in "$@"; do
    if [[ "$pattern" == "Dockerfile" ]]; then
      # Gère Dockerfile (avec ou sans casse, et sous-répertoires)
      while IFS= read -r -d '' file; do
        [[ -n "${seen[$file]}" ]] && continue
        seen[$file]=1
        echo "===== $file =====" >> "$outfile"
        cat "$file" >> "$outfile"
        echo -e "\n" >> "$outfile"
      done < <(find . -type f \( -name "Dockerfile" -o -iname "dockerfile" \) -print0)
    else
      # Motif standard (ex: *.js, *.py, *.md, *.sh)
      while IFS= read -r -d '' file; do
        [[ -n "${seen[$file]}" ]] && continue
        seen[$file]=1
        echo "===== $file =====" >> "$outfile"
        cat "$file" >> "$outfile"
        echo -e "\n" >> "$outfile"
      done < <(find . -type f -iname "$pattern" -print0)
    fi
  done

  echo "✅ Terminé → $outfile"
}

# 🔧 Menu TOOLS
function tools() {

  # --- helper: exécuter une option ---
  run_tools_choice() {
    case "$1" in
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
        concat_files "liste-js.txt" "*.js"
        ;;
      4)
        echo "📜 Concaténation des fichiers .sh..."
        concat_files "liste-sh-concat.txt" "*.sh"
        ;;
      5)
        echo "📘 Concaténation des fichiers .md..."
        concat_files "liste-md.txt" "*.md"
        ;;
      6)
        github
        ;;
      7)
        echo "👋 Bye !"
        ;;
      8)
        echo "🐍 Concaténation des fichiers .py..."
        concat_files "liste-py.txt" "*.py"
        ;;
      9)
        echo "🐳 Concaténation des Dockerfile..."
        concat_files "liste-dockerfile.txt" "Dockerfile"
        ;;
      10)
        echo "🧩 Combo personnalisée"
        echo "   Tape les types séparés par des espaces : js py sh md docker"
        echo -n "   Types : "
        read types

        patterns=()
        for t in $types; do
          case "$t" in
            js)     patterns+=('*.js') ;;
            py)     patterns+=('*.py') ;;
            sh)     patterns+=('*.sh') ;;
            md)     patterns+=('*.md') ;;
            docker) patterns+=('Dockerfile') ;;
            *) echo "⚠️ Type inconnu ignoré: $t" ;;
          esac
        done

        if [[ ${#patterns[@]} -eq 0 ]]; then
          echo "❌ Aucun type valide fourni."
          return
        fi

        echo -n "   Nom du fichier de sortie (defaut: liste-combo.txt) : "
        read outfile
        [[ -z "$outfile" ]] && outfile="liste-combo.txt"

        echo "📚 Concaténation → ${patterns[*]}"
        concat_files "$outfile" "${patterns[@]}"
        ;;
      *)
        echo "❌ Choix invalide: $1"
        ;;
    esac
  }

  # --- affichage menu ---
  echo "🧰 Menu TOOLS"
  echo "1) Afficher l'arborescence (structure.txt)"
  echo "2) Lister les fichiers .sh (liste-sh.txt)"
  echo "3) Concaténer les .js avec titres (liste-js.txt)"
  echo "4) Concaténer les .sh avec titres (liste-sh-concat.txt)"
  echo "5) Concaténer les .md avec titres (liste-md.txt)"
  echo "6) Menu GitHub"
  echo "7) Quitter"
  echo "8) Concaténer les .py (liste-py.txt)"
  echo "9) Concaténer les Dockerfile (liste-dockerfile.txt)"
  echo "10) Concaténer combo (ex: js+py, js+docker, py+docker, etc.)"
  echo -n "Ton choix (ex: 3+2, 3,2, 3 2, 3-5) : "
  read raw

  # --- parsing multi-sélection ---
  # normalise séparateurs: + , ; → espaces
  input=$(echo "$raw" | tr '+,;' '   ')

  to_run=()
  for token in $input; do
    if [[ "$token" =~ ^([0-9]+)-([0-9]+)$ ]]; then
      start="${BASH_REMATCH[1]}"
      end="${BASH_REMATCH[2]}"
      if (( start <= end )); then
        for ((i=start; i<=end; i++)); do to_run+=("$i"); done
      else
        for ((i=start; i>=end; i--)); do to_run+=("$i"); done
      fi
    else
      to_run+=("$token")
    fi
  done

  # exécution séquentielle
  for choice in "${to_run[@]}"; do
    run_tools_choice "$choice"
  done
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
