# Liste des scripts Bash

## ./bash-tools/get-structure.sh

```bash
# Affiche la structure parent enfant d'un dossier. 
find . | awk -F/ '{ 
  indent = "";
  for(i=2; i<NF; i++) indent = indent "│   ";
  if (NF>1) print indent "├── " $NF;
  else print $0;
}' > structure.txt

# Affiche les fichier .sh du dossier et sous dossier
find . -type f -name "*.sh" > liste-sh.txt
```

## ./create-repo.sh

```bash
#!/bin/bash

echo "🚀 Création d’un nouveau dépôt GitHub"

# Demande le nom du repo (nom du dossier courant par défaut)
default_name=$(basename "$PWD")
read -p "📝 Nom du dépôt [$default_name] : " repo_name
repo_name=${repo_name:-$default_name}

# Demande une description
read -p "📄 Description du dépôt : " description

# Demande la visibilité
echo "🔐 Visibilité :"
select visibility in "public" "private"; do
  if [[ "$visibility" == "public" || "$visibility" == "private" ]]; then
    break
  else
    echo "❌ Choix invalide. Réessaie."
  fi
done

# Crée le repo GitHub
echo "🔧 Création du dépôt distant sur GitHub..."
gh repo create "$repo_name" --"$visibility" --description "$description" --source=. --remote=origin --push

if [ $? -eq 0 ]; then
  echo "✅ Dépôt '$repo_name' créé avec succès et lié à ton dossier local."
else
  echo "❌ Échec de la création du dépôt."
fi
```

## ./delete-repo.sh

```bash
#!/bin/bash

echo "🗑️ Suppression d'un dépôt GitHub"

read -p "🔧 Nom du repo (ex: mon-repo ou wilonweb/mon-repo) : " INPUT

if [[ "$INPUT" == *"/"* ]]; then
  REPO="$INPUT"
else
  REPO="wilonweb/$INPUT"
fi

echo "⚠️ Tu t'apprêtes à supprimer le dépôt : $REPO"
echo "🚨 Cette action est irréversible !"

read -p "✋ Confirmer la suppression ? (o/n) : " CONFIRM

if [[ "$CONFIRM" != "o" ]]; then
  echo "❌ Annulé."
  exit 1
fi

gh repo delete "$REPO" --confirm
```

## ./list-repo.sh

```bash
#!/bin/bash

# Vérifie si gh CLI est disponible
if ! command -v gh &> /dev/null; then
  echo "❌ GitHub CLI (gh) non trouvé. Installe-le ici : https://cli.github.com/"
  exit 1
fi

# Sélection du type
echo "🔍 Quel type de dépôts veux-tu afficher ?"
select TYPE in "all" "public" "private"; do
  case $TYPE in
    all|public|private)
      break
      ;;
    *)
      echo "❌ Choix invalide. Réessaie."
      ;;
  esac
done

# Lister les repos
echo "📦 Dépôts $TYPE :"
gh repo list --visibility "$TYPE" --limit 100 --json name,visibility,description -q '.[] | "\(.visibility) - \(.name): \(.description // "Aucune description")"'
```

## ./make-public.sh

```bash
#!/bin/bash

echo "🔓 Passage d’un dépôt GitHub en public"
read -p "Nom du dépôt (ex: mon-repo) : " repo

# Ajoute ton nom d'utilisateur GitHub ici si absent
username="wilonweb"

echo "🚀 Passage en public de https://github.com/$username/$repo..."

gh repo edit "$username/$repo" \
  --visibility public \
  --accept-visibility-change-consequences && \
  echo "✅ Le dépôt est maintenant public." || \
  echo "❌ Une erreur s'est produite."
```

## ./private-all.sh

```bash
#!/bin/bash

# Ce script rend tous tes repos en privé (⚠️ irréversible sauf manuellement)

echo "🔐 Début : rendre tous les dépôts privés..."
gh repo list $USER --limit 100 --json name,visibility --jq '.[] | select(.visibility == "public") | .name' |
while read repo; do
  echo "➡️  Repo : $repo → privé"
  gh repo edit "$USER/$repo" --visibility private
done
echo "✅ Tous les dépôts publics sont maintenant privés."
```

## ./togle-visibility.sh

```bash
#!/bin/bash

echo "🔁 Changement de visibilité d'un dépôt GitHub"

read -p "🔧 Nom du repo (ex: wilonweb/mon-repo) : " REPO
read -p "🎯 Nouvelle visibilité (public/private) : " VISIBILITY

if [[ "$VISIBILITY" != "public" && "$VISIBILITY" != "private" ]]; then
  echo "❌ Visibilité invalide. Choisis 'public' ou 'private'."
  exit 1
fi

echo "⚠️ Tu vas modifier la visibilité du dépôt : $REPO → $VISIBILITY"
read -p "✅ Confirmer ? (o/n) : " CONFIRM

if [[ "$CONFIRM" != "o" ]]; then
  echo "❌ Opération annulée."
  exit 1
fi

gh repo edit "$REPO" --visibility "$VISIBILITY" --accept-visibility-change-consequences

if [ $? -eq 0 ]; then
  echo "✅ Visibilité mise à jour avec succès pour $REPO"
else
  echo "❌ Échec de la mise à jour. Vérifie le nom du repo et ton accès."
fi
```
