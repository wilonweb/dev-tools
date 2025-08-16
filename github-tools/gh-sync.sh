#!/usr/bin/env bash
set -euo pipefail

# === Réglages ===
ROOT="${ROOT:-$HOME/Code}"        # dossier où cloner/mettre à jour
USE_HTTPS="${GITHUB_USE_HTTPS:-0}"# 1 = utiliser HTTPS au lieu de SSH
DRY_RUN="${DRY_RUN:-0}"           # 1 = ne fait qu'afficher les actions

need() { command -v "$1" >/dev/null 2>&1 || { echo "❌ $1 manquant"; exit 1; }; }
need gh; need git; mkdir -p "$ROOT"

# Détecte le login GitHub si possible
USERNAME="${USERNAME:-}"
if [[ -z "${USERNAME}" ]]; then
  USERNAME="$(gh api user --jq .login 2>/dev/null || true)"
fi
if [[ -z "${USERNAME}" ]]; then
  read -rp "GitHub username: " USERNAME
fi

echo "🔍 Quel type de dépôts veux-tu SYNC ?"
echo "1) Tous"
echo "2) Publics"
echo "3) Privés"
echo "4) Templates"
read -rp "#? " choice

case "$choice" in
  1) FILTER='true' ;;
  2) FILTER='.visibility=="public"' ;;
  3) FILTER='.visibility=="private"' ;;
  4) FILTER='.isTemplate==true' ;;
  *) echo "❌ Choix invalide"; exit 1 ;;
esac

echo "📡 Récupération de la liste des dépôts de $USERNAME…"
# Pas besoin de jq installé : --jq est intégré à gh
REPOS="$(gh repo list "$USERNAME" --limit 200 \
  --json name,sshUrl,url,visibility,isTemplate \
  --jq ".[] | select($FILTER) | [.name,.sshUrl,.url] | @tsv")"

if [[ -z "$REPOS" ]]; then
  echo "⚠️ Aucun dépôt trouvé pour ce filtre."; exit 0
fi

echo "📂 Dossier cible: $ROOT"
while IFS=$'\t' read -r NAME SSHURL HTTPSURL; do
  [[ -n "$NAME" ]] || continue
  DEST="$ROOT/$NAME"
  REMOTE="$SSHURL"; [[ "$USE_HTTPS" = "1" ]] && REMOTE="$HTTPSURL"

  if [[ ! -d "$DEST/.git" ]]; then
    echo "📥 clone  $NAME → $DEST"
    [[ "$DRY_RUN" = "1" ]] || git clone "$REMOTE" "$DEST"
  else
    echo "🔄 sync   $NAME"
    (
      cd "$DEST"
      [[ "$DRY_RUN" = "1" ]] || git fetch -q
      read -r A B <<<"$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null || echo '0 0')"
      STATUS="sync"
      [[ "$B" != 0 && "$A" == 0 ]] && STATUS="pull"
      [[ "$A" != 0 && "$B" == 0 ]] && STATUS="push"
      [[ "$A" != 0 && "$B" != 0 ]] && STATUS="diverged"
      echo "   → $STATUS (ahead:$A behind:$B)"
      if [[ "$DRY_RUN" != "1" && "$B" != 0 ]]; then git pull --ff-only || true; fi
    )
  fi
done <<< "$REPOS"

echo "✅ Terminé."
