#!/usr/bin/env bash
set -euo pipefail

USERNAME="${USERNAME:-wilonweb}"

echo "🔍 Quel type de dépôts veux-tu afficher ?"
echo "1) Tous"
echo "2) Publics"
echo "3) Privés"
echo "4) Templates"
read -r -p "#? " choice

case "$choice" in
  1) gh repo list "$USERNAME" --limit 200 ;;
  2) gh repo list "$USERNAME" --visibility public --limit 200 ;;
  3) gh repo list "$USERNAME" --visibility private --limit 200 ;;
  4) gh repo list "$USERNAME" --limit 200 --json name,isTemplate,visibility \
       --jq '.[] | select(.isTemplate==true) | "\(.visibility | ascii_upcase) - \(.name)"' ;;
  *) echo "❌ Choix invalide"; exit 1 ;;
esac
