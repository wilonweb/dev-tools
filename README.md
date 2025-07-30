# ⚙️ Dev Tools — Outils de Terminal pour GitHub & Fichiers

Ce dossier regroupe des **fonctions Bash/Zsh personnalisées**, regroupées dans deux menus :

- `tools` → arborescence, concaténation de fichiers `.sh`, `.js`, `.md`...
- `github` → actions GitHub via la CLI `gh`

Ces deux menus sont disponibles directement dans ton terminal.

---

## 🧰 Commandes disponibles

### 📁 `tools` (menu général)

```bash
tools
````

Propose :

* Générer un fichier `structure.txt` avec l’arborescence
* Lister les fichiers `.sh`
* Concaténer tous les fichiers `.js`, `.sh`, `.md`
* Lancer le menu GitHub

### 🐙 `github` (menu GitHub CLI)

```bash
github
```

Permet de :

* Créer un dépôt GitHub (`gh repo create`)
* Supprimer un dépôt GitHub
* Lister les dépôts
* Passer un repo en public
* Passer tous les repos en privé
* Modifier la visibilité d’un dépôt

---

## 📁 Organisation

```
dev-tools/
├── bash-tools/
│   ├── bashrc.sh          ← Toutes les fonctions sont là
│   ├── get-structure.sh   ← Script brut pour structure + .sh
│   └── github.sh          ← Menu GitHub seul (doublon de bashrc.sh)
├── github-tools/
│   ├── create-repo.sh
│   ├── delete-repo.sh
│   ├── list-repo.sh
│   ├── make-public.sh
│   ├── private-all.sh
│   ├── togle-visibility.sh
│   └── liste-template.sh
└── README.md              ← Ce fichier
```

---

## 🔧 Modifier / Ajouter une fonction

Tout se passe dans ce fichier :

```bash
~/Documents/VisualStudioCode/dev-tools/bash-tools/bashrc.sh
```

Ajoute une nouvelle fonction comme ceci :

```bash
function hello() {
  echo "Hello World"
}
```

Puis recharge ton shell (voir ci-dessous).

---

## 🔄 Activer les modifications

### ✅ Sous **WSL (Zsh)**

```bash
source ~/.zshrc
```

ou

```bash
reload  # si tu as défini alias reload="source ~/.zshrc"
```

### ✅ Sous **Git Bash**

```bash
source ~/.bashrc
```

Ou redémarre Git Bash.

---

## 🧠 Astuces et alias

Ajoute dans ton `~/.zshrc` ou `~/.bashrc` :

```bash
# Accès rapide
alias zshconfig="code ~/.zshrc"
alias bashconfig="code ~/.bashrc"
alias reload="source ~/.zshrc"
```

---

## ✅ Pré-requis

* [x] Avoir installé [`gh`](https://cli.github.com/)
* [x] Être connecté via `gh auth login`
* [x] Avoir cloné ou créé ce dossier `dev-tools`

---

## ✅ Exemple

```bash
tools
# ↪ Choix : 1 → structure.txt
# ↪ Choix : 6 → ouvre le menu GitHub
```

```bash
github
# ↪ Choix : 1 → Créer un nouveau dépôt GitHub
```

---

## 🛠️ TODO (Améliorations à venir)

* [ ] Créer une commande `devtools` globale qui fusionne `tools` + `github`
* [ ] Ajouter un script `install.sh` pour tout configurer automatiquement (`.zshrc`, `.bashrc`, `alias`, etc.)
* [ ] Créer une version **portable** du dossier (archivable ou clonable sur un autre PC ou en cloud)
* [ ] Ajouter un log (`logs/github.log`) pour tracer les actions
* [ ] Ajouter une fonction `openrepo` pour ouvrir le dépôt GitHub courant
* [ ] Ajouter une fonction `gitstatusall` pour voir l'état de plusieurs dépôts
* [ ] Ajouter un raccourci `ghpush` qui crée le dépôt si inexistant (`gh repo create ...`)
* [ ] Générer un README automatique avec `tools` ou `github`

---

## 👤 Auteur

**Wilfried**

> Terminal addict · DevOps-curieux · Indie Hacker
> 📍 Terminal préféré : Zsh (WSL) + Git Bash
> 🔗 GitHub : [github.com/wilonweb](https://github.com/wilonweb)

```
