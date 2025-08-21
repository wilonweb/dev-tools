# ────────────────────────────────────────────────────────────────
# 📦 TOOLS (1: structure, 2: lister, 3: concat, 4: github, 5: quit)
# ────────────────────────────────────────────────────────────────

# Helpers ---------------------------------------------------------

_str_to_array() {  # "a b c" -> ["a","b","c"]
  local s="$1"; local -n _out="$2"
  _out=(); for d in $s; do _out+=("$d"); done
}

_build_types_expr() {  # map types connus + globs -> expr find
  local -a in_patterns=("$@")
  local -a expr=()
  for p in "${in_patterns[@]}"; do
    case "$p" in
      js)   expr+=( -iname '*.js' -o -iname '*.mjs' -o -iname '*.cjs' -o ) ;;
      ts)   expr+=( -iname '*.ts' -o -iname '*.tsx' -o ) ;;
      py)   expr+=( -iname '*.py' -o ) ;;
      sh)   expr+=( -iname '*.sh' -o ) ;;
      md)   expr+=( -iname '*.md' -o -iname '*.markdown' -o ) ;;
      docker)
        expr+=(
          -iname 'Dockerfile' -o
          -iname 'Dockerfile.*' -o
          -iname '*.dockerfile' -o
          -iname '.dockerignore' -o
          -iname 'docker-compose*.yml' -o
          -iname 'docker-compose*.yaml' -o
          -iname 'compose.yml' -o
          -iname 'compose.yaml' -o
          -path '*/docker/*' -o
        )
        ;;
      *)    expr+=( -iname "$p" -o ) ;;  # glob brut tel quel (ex: *.yml, Makefile)
    esac
  done
  [[ ${#expr[@]} -gt 0 && "${expr[-1]}" == "-o" ]] && unset 'expr[-1]'
  printf '%s\n' "${expr[@]}"
}

_build_prune_expr() {  # "node_modules .git dist" -> expr prune robuste
  local ignores="$1"
  local -a ig=(); _str_to_array "$ignores" ig
  local -a prune=()
  for d in "${ig[@]}"; do
    d="${d%/}"                       # enlève trailing slash éventuel
    [[ -z "$d" ]] && continue
    # On match le dossier et tout son contenu, insensible à la casse.
    prune+=( -ipath "*/$d" -o -ipath "*/$d/*" -o )
  done
  [[ ${#prune[@]} -gt 0 ]] && unset 'prune[-1]'
  printf '%s\n' "${prune[@]}"
}

_find_files() {  # uses arrays; no eval
  local ignores="$1"; shift
  local -a types_expr=("$@")
  local -a prune_expr=(); mapfile -t prune_expr < <(_build_prune_expr "$ignores")

  if ((${#prune_expr[@]})); then
    # -prune bloque la descente; '-o' passe à la branche fichiers
    find . \( "${prune_expr[@]}" \) -prune -o -type f \( "${types_expr[@]}" \) -print0
  else
    find . -type f \( "${types_expr[@]}" \) -print0
  fi
}

_print_structure() {
  local ignores="$1"
  local -a prune_expr=(); mapfile -t prune_expr < <(_build_prune_expr "$ignores")
  if ((${#prune_expr[@]})); then
    find . \( "${prune_expr[@]}" \) -prune -o -print \
    | awk -F/ '{
        indent=""; for(i=2;i<NF;i++) indent=indent"│   ";
        if (NF>1) print indent "├── " $NF; else print $0;
      }'
  else
    find . -print \
    | awk -F/ '{
        indent=""; for(i=2;i<NF;i++) indent=indent"│   ";
        if (NF>1) print indent "├── " $NF; else print $0;
      }'
  fi
}

_list_files() {
  local ignores="$1"; shift
  local outfile="$1"; shift
  local -a patterns=("$@")

  mapfile -t types_expr < <(_build_types_expr "${patterns[@]}")
  if ((${#types_expr[@]}==0)); then echo "❌ Aucun motif/type."; return 1; fi

  : > "$outfile"
  while IFS= read -r -d $'\0' f; do
    printf '%s\n' "$f" >> "$outfile"
  done < <(_find_files "$ignores" "${types_expr[@]}")
  echo "✅ Liste écrite → $outfile"
}

_concat_files() {
  local ignores="$1"; shift
  local outfile="$1"; shift
  local -a patterns=("$@")

  mapfile -t types_expr < <(_build_types_expr "${patterns[@]}")
  if ((${#types_expr[@]}==0)); then echo "❌ Aucun motif/type."; return 1; fi

  : > "$outfile"
  declare -A seen
  while IFS= read -r -d $'\0' f; do
    [[ -n "${seen[$f]}" ]] && continue
    seen[$f]=1
    {
      echo "===== $f ====="
      cat "$f"
      echo
    } >> "$outfile"
  done < <(_find_files "$ignores" "${types_expr[@]}")
  echo "✅ Concat terminé → $outfile"
}

# Menu ------------------------------------------------------------

tools() {
  run_choice() {
    case "$1" in
      1)
        echo -n "🧹 Dossiers à ignorer pour la STRUCTURE (ex: node_modules .git dist) : "
        read ignores
        echo "📁 Génération de structure.txt (ignores: ${ignores:-aucun})..."
        _print_structure "$ignores" > structure.txt
        echo "✅ structure.txt prêt"
        ;;
      2)
        echo "🔎 Lister des fichiers par types/globs"
        echo "   Types connus: js py sh md ts docker  |  Globs: *.tsx *.yml Dockerfile Makefile"
        echo -n "   Motifs/types (séparés par espaces) : "
        read line; [[ -z "$line" ]] && { echo "❌ Aucun motif."; return; }
        read -r -a patterns <<< "$line"
        echo -n "🧹 Dossiers à ignorer (vide = aucun) : "
        read ignores
        echo -n "📄 Nom du fichier de sortie (défaut: liste.txt) : "
        read outfile; [[ -z "$outfile" ]] && outfile="liste.txt"
        _list_files "$ignores" "$outfile" "${patterns[@]}"
        ;;
      3)
        echo "📚 Concaténer des fichiers par types/globs"
        echo "   Types connus: js py sh md ts docker  |  Globs: *.tsx *.yml Dockerfile Makefile"
        echo -n "   Motifs/types (séparés par espaces) : "
        read line; [[ -z "$line" ]] && { echo "❌ Aucun motif."; return; }
        read -r -a patterns <<< "$line"
        echo -n "🧹 Voulez-vous ignorer des dossiers ? (laisser vide si non) : "
        read ignores
        echo -n "📄 Nom du fichier de sortie (défaut: concat.txt) : "
        read outfile; [[ -z "$outfile" ]] && outfile="concat.txt"
        _concat_files "$ignores" "$outfile" "${patterns[@]}"
        ;;
      4)
        github
        ;;
      5)
        echo "👋 Bye"
        ;;
      *)
        echo "❌ Choix invalide: $1"
        ;;
    esac
  }

  echo "🧰 Menu TOOLS"
  echo "1) Afficher l'arborescence (structure.txt)"
  echo "2) Lister les fichiers (filtres: types + globs)"
  echo "3) Concaténer (filtres: types + globs)"
  echo "4) Menu GitHub"
  echo "5) Quitter"
  echo -n "Ton choix : "
  read raw
  for choice in $(echo "$raw" | tr ',+' ' '); do run_choice "$choice"; done
}

# Menu GitHub (à adapter à tes chemins)
github() {
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
    7) echo "👋 Retour" ;;
    *) echo "❌ Choix invalide" ;;
  esac
}
