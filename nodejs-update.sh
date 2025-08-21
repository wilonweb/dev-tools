# === update-node-wsl.sh ===
set -e

# 1) Pré-requis
sudo apt-get update -y
sudo apt-get install -y curl ca-certificates

# 2) Installer/mettre à jour nvm
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  echo "nvm déjà présent dans $NVM_DIR"
fi

# 3) Charger nvm dans ce shell
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1090
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# 4) Installer Node LTS et le définir par défaut
nvm install --lts
nvm alias default lts/*
nvm use default

# 5) Afficher les versions
echo "✅ Versions actives :"
node -v
npm -v
