``` shell
sudo ln -sf ~/.dotfiles/scripts ~/scripts

sudo ln -sf ~/.dotfiles/.bashrc ~/.bashrc
sudo ln -sf ~/.dotfiles/.capsEsc ~/.capsEsc
sudo ln -sf ~/.dotfiles/.inputrc ~/.inputrc
sudo ln -sf ~/.dotfiles/dunstrc ~/.config/dunst/dunstrc
sudo ln -sf ~/.dotfiles/i3 ~/.config/i3/config
sudo ln -sf ~/.dotfiles/powerline-shell-config.json ~/.config/powerline-shell/config.json
sudo ln -sf ~/.dotfiles/greenclip.cfg ~/.config/greenclip.cfg
sudo ln -sf ~/.dotfiles/.alacritty.yml ~/.alacritty.yml
sudo ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
sudo ln -s ~/.dotfiles/scripts/bash-powerline.sh ~/.bash-powerline.sh

mkdir -p ~/.config/i3status
sudo ln -sf ~/.dotfiles/i3status ~/.config/i3status/config

sudo ln -sf ~/.dotfiles/erlang_ls.config ~/.config/erlang_ls/erlang_ls.config

mkdir -p ~/.lsp
sudo ln -sf ~/.dotfiles/clojure-lsp-config.edn ~/.lsp/config.edn
```
