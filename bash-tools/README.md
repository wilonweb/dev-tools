
# 🛠️ Tools Bash : Menu interactif Git Bash

Ce projet ajoute une fonction `tools` dans votre terminal Git Bash, permettant d'exécuter des commandes utiles via un menu interactif.

---

## ✅ Installation

1. Ouvrez votre fichier `.bashrc` :
   ```bash
   code ~/.bashrc


2. Collez le bloc suivant à la fin du fichier :

   ```bash
   function tools() { 
     echo "Que veux-tu faire ?"
     echo "1) Afficher l'arborescence (structure.txt)"
     echo "2) Lister les fichiers .sh (liste-sh.txt)"
     echo "3) Quitter"
     read -p "Ton choix : " choice

     case $choice in
       1)
         echo "📁 Génération de l'arborescence dans structure.txt..."
         find . | awk -F/ '{ indent = ""; for(i=2; i<NF; i++) indent = indent "│   "; if (NF>1) print indent "├── " $NF; else print $0; }' > structure.txt
         echo "✅ Terminé"
         ;;
       2)
         echo "🔍 Liste des fichiers .sh dans liste-sh.txt..."
         find . -type f -name "*.sh" > liste-sh.txt
         echo "✅ Terminé"
         ;;
       3)
         echo "👋 Bye !"
         ;;
       *)
         echo "❌ Choix invalide"
         ;;
     esac
   }
   ```

3. Rechargez votre `.bashrc` :

   ```bash
   source ~/.bashrc
   ```

---

## 🚀 Utilisation

Dans n'importe quel dossier, ouvrez Git Bash et tapez simplement :

```bash
tools
```

Un menu s’affichera pour choisir l’action :

```
Que veux-tu faire ?
1) Afficher l'arborescence (structure.txt)
2) Lister les fichiers .sh (liste-sh.txt)
3) Quitter
```

---

## 📂 Résultats

* `structure.txt` : contient la structure du dossier avec indentation.
* `liste-sh.txt` : contient la liste de tous les fichiers `.sh` présents dans le dossier et ses sous-dossiers.

---

## 💡 Astuce

Vous pouvez modifier ou ajouter d’autres choix dans la fonction `tools` pour automatiser encore plus de tâches utiles (compter les lignes, rechercher un mot, ouvrir un fichier, etc.).

---

## 🔒 Compatibilité

* ✅ Git Bash sous Windows
* ✅ Terminal Bash sous Linux ou WSL

```
