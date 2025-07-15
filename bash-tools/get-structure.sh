# Affiche la structure parent enfant d'un dossier. 
find . | awk -F/ '{ 
  indent = "";
  for(i=2; i<NF; i++) indent = indent "│   ";
  if (NF>1) print indent "├── " $NF;
  else print $0;
}' > structure.txt

# Affiche les fichier .sh du dossier et sous dossier
find . -type f -name "*.sh" > liste-sh.txt
