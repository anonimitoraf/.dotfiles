# New mint setup

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install --cask font-fantasque-sans-mono-nerd-font

# open Software Sources and enable "Source code repositories"

sudo apt update && sudo apt upgrade
sudo apt install vim i3 steam hstr rofialacritty i3blocks libmagickwand-dev htop fd-find ripgrep cmake gparted tmux
sudo apt install libtool-bin # IMPORTANT for compiling vterm!!!

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# node
export NVS_HOME="$HOME/.nvs"
git clone https://github.com/jasongin/nvs "$NVS_HOME"
. "$NVS_HOME/nvs.sh" install

# sign in to firefox, bitwarden, github, gmail

# install gh cli
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
gh auth login

# clone repos
gh repo clone anonimitoraf/.dotfiles # then follow readme
gh repo clone anonimitoraf/.doom.d ~/.config/doom

# set up emacs
mkdir -p ~/foss && cd ~/foss
git clone --depth 1 --branch emacs-30 git://git.savannah.gnu.org/emacs.git
cd emacs
git checkout emacs-30
sudo apt build-dep -y emacs && sudo apt install libtree-sitter-dev
./autogen.sh
./configure --with-imagemagick --with-tree-sitter --with-native-compilation=aot --with-x --with-mailutils
sudo make -j$(nproc) bootstrap
sudo make install

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

# set up dropbox (via deb file)
sudo apt install gir1.2-gtk-4.0 # required dependency
sudo dpkg -i dropbox_*_.deb

# set up docker
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  jammy stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER # then restart

# set up qbittorrent, plex (see .dotfiles/scripts)

# set up opencode
curl -fsSL https://opencode.ai/install | bash

# set up godot (from website download)
cd "~/Downloads"
export godot_filename="Godot_v4.6-stable_linux.x86_64" # (change this depending on the version at the time)
unzip "${godot_filename}.zip"
sudo mv "${godot_filename}" "/usr/local/bin/godot"
mkdir -p "~/games"
