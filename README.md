# 🐙 GitHub Tools — Scripts CLI GitHub + Menu Terminal

Ce dossier contient des **scripts Bash** qui automatisent des actions GitHub via l'outil [`gh`](https://cli.github.com/).  
Ils sont accessibles via un **menu terminal interactif** avec la commande :

```bash
github
````

---

## 📁 Contenu

| Script                | Description                               |
| --------------------- | ----------------------------------------- |
| `create-repo.sh`      | Crée un nouveau dépôt GitHub              |
| `delete-repo.sh`      | Supprime un dépôt GitHub                  |
| `list-repo.sh`        | Liste tous les dépôts                     |
| `make-public.sh`      | Rend un dépôt public                      |
| `private-all.sh`      | Rend tous les dépôts privés               |
| `togle-visibility.sh` | Modifie la visibilité d’un dépôt          |
| `liste-template.sh`   | Liste les dépôts configurés comme modèles |

> ⚠️ Tous ces scripts nécessitent l'outil `gh`. Connecte-toi une fois avec :

```bash
gh auth login
```

---

## 🚀 Utilisation rapide

```bash
github   # Ouvre le menu GitHub CLI
tools    # Ouvre le menu pour fichiers (concaténation, structure…)
```

Chaque option guide l'utilisateur pas à pas.

---

## ⚙️ Ajouter ou modifier des fonctions terminal

Toutes tes fonctions perso (`tools`, `github`, etc.) sont regroupées dans :

```
~/Documents/VisualStudioCode/dev-tools/bash-tools/bashrc.sh
```

Pour ajouter une nouvelle commande (`function mafonction() { ... }`), édite simplement ce fichier.

---

## 🔄 Activer les modifications

### ✅ Sous **Git Bash**

Après modification de `bashrc.sh`, tape :

```bash
source ~/.bashrc
```

Ou redémarre Git Bash.

---

### ✅ Sous **WSL (Ubuntu / Zsh)**

Après modification de `bashrc.sh`, tape :

```bash
source ~/.zshrc
```

Ou utilise l’alias si configuré :

```bash
reload
```

---

## 🧠 Aliases recommandés

Dans `.zshrc` (ou `.bashrc`), ajoute :

```bash
alias zshconfig="code ~/.zshrc"
alias reload="source ~/.zshrc"
```

---

## ✅ TODO / Améliorations à venir

* [ ] Ajouter un menu `devtools` global regroupant `tools`, `github`, etc.
* [ ] Ajouter un fichier `.env` pour centraliser des variables (nom utilisateur GitHub…)
* [ ] Ajouter un mode `dry-run` (prévisualisation) avant action
* [ ] Ajouter un `install.sh` pour configurer automatiquement `.bashrc` et `.zshrc`
* [ ] Ajouter un système de log des actions (`logs/github.log`)
* [ ] Créer une version **portable** de cette configuration, pour la réutiliser facilement sur d'autres PC ou dans le cloud (type script d'installation ou dépôt clonable)

---

## 📝 Journal de développement

Voir [`Journal.md`](./Journal.md)

---

## 👤 Auteur

**Wilfried**

> Passionné de scripting, automatisation, DevOps, et indie hacking
> Terminal favori : `Zsh` + `Git Bash`
> 💻 Objectif : une boîte à outils CLI réutilisable partout

