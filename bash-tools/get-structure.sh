#!/usr/bin/env bash
set -euo pipefail

# Structure arborescente
find . \( -path "./.git" -o -path "./node_modules" \) -prune -o -print \
| awk -F/ '{ indent=""; for(i=2;i<NF;i++) indent=indent"│   "; if(NF>1) print indent "├── " $NF; else print $0; }' \
> structure.txt

# Liste des .sh
find . \( -path "./.git" -o -path "./node_modules" \) -prune -o -type f -name "*.sh" -print > liste-sh.txt
