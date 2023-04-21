```shell
git clone git@github.com:anonimitoraf/dotfiles.git --recurse-submodules ~/.dotfiles
```


``` shell
sudo ln -sf ~/.dotfiles/scripts ~/scripts

sudo ln -sf ~/.dotfiles/.bashrc ~/.bashrc
sudo ln -sf ~/.dotfiles/.bash_utils ~/.bash_utils
sudo ln -sf ~/.dotfiles/.capsEsc ~/.capsEsc
sudo ln -sf ~/.dotfiles/.inputrc ~/.inputrc
sudo ln -sf ~/.dotfiles/dunstrc ~/.config/dunst/dunstrc
sudo ln -sf ~/.dotfiles/i3 ~/.config/i3/config
sudo ln -sf ~/.dotfiles/powerline-shell-config.json ~/.config/powerline-shell/config.json
sudo ln -sf ~/.dotfiles/greenclip.cfg ~/.config/greenclip.cfg
sudo ln -sf ~/.dotfiles/.alacritty.yml ~/.alacritty.yml
sudo ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
sudo ln -sf ~/.dotfiles/.tmux ~/.tmux
sudo ln -sf ~/.dotfiles/scripts/bash-powerline.sh ~/.bash-powerline.sh
sudo ln -sf ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf

mkdir -p ~/.config/rofi
sudo ln -s ~/.dotfiles/rofi.config.rasi ~/.config/rofi/config.rasi

mkdir -p ~/.config/i3status
sudo ln -sf ~/.dotfiles/i3status ~/.config/i3status/config

sudo ln -sf ~/.dotfiles/erlang_ls.config ~/.config/erlang_ls/erlang_ls.config

mkdir -p ~/.lsp
sudo ln -sf ~/.dotfiles/clojure-lsp-config.edn ~/.lsp/config.edn
sudo ln -sf ~/.dotfiles/.zprint.edn ~/.zprint.edn

mkdir -p ~/.config/yabai
sudo ln -sf ~/.dotfiles/yabairc ~/.config/yabai/yabairc

mkdir -p ~/.config/skhd
sudo ln -sf ~/.dotfiles/skhdrc ~/.config/skhd/skhdrc

sudo ln -sf ~/.dotfiles/z.sh ~/z.sh
```
