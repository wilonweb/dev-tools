# 🔧 gh-tools

Scripts CLI pour gérer ses dépôts GitHub plus rapidement depuis le terminal.

## 📁 Ce que contient ce dossier

Voici les scripts que tu peux utiliser :

| Script                | Description                                               |
|----------------------|-----------------------------------------------------------|
| `list-repo.sh`       | Affiche tous tes dépôts GitHub (all, public, private)     |
| `private-all.sh`     | Rend tous tes dépôts publics → privés                     |
| `toggle-visibility.sh` | Change la visibilité d’un dépôt (public/private)        |
| `delete-repo.sh`     | Supprime un dépôt GitHub (⚠️ action irréversible)        |

---

## ⚙️ Pré-requis

- GitHub CLI (`gh`) installé
- Connexion établie avec `gh auth login`
- Pour certaines actions sensibles comme supprimer un dépôt :


## 🧠 Améliorations

### 🔄 Organisation

* Regrouper tous les scripts dans un sous-dossier `cli/` ou `scripts/` pour plus de clarté.
* Ajouter un script `setup.sh` pour rendre tous les `.sh` exécutables automatiquement (`chmod +x *.sh`).
* Ajouter un script de test automatique pour valider les accès (`gh auth status` + test de requête API).

### 📖 Documentation

* Ajouter une structure de dossier dans le `README.md` avec `tree` ou un bloc ascii.
* Ajouter une section "Utilisation rapide" avec les commandes les plus utiles.
* Ajouter un lien vers la doc GitHub CLI officielle : [https://cli.github.com/manual/](https://cli.github.com/manual/)

### 🧪 UX des scripts

* Ajouter des **vérifications automatiques** dans chaque script : est-ce que le repo existe ? est-ce que l’utilisateur a les droits ?
* Ajouter une option `--yes` dans les confirmations (mode non-interactif).
* Pour `list-repo.sh`, proposer une option en ligne de commande directe : `./list-repo.sh public`

### 💡 Nouvelles fonctionnalités

* Ajouter un script `clone-all.sh` : cloner tous ses repos GitHub automatiquement.
* Ajouter un script `archive-old-repos.sh` : archiver automatiquement les vieux repos (> 6 mois sans push).
* Ajouter un script `rename-repo.sh` : renommer un repo à la volée.
