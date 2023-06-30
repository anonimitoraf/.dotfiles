#!/bin/bash

alias fs="thunar ."
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias dired='bash ~/.dotfiles/scripts/dired.sh'
alias d=dired

# Haskell
alias ghci-auto="ghcid '--command=stack ghci' --test=main"
alias h='hoogle --count=5'

# Clojure
alias comfykafka="node ~/work/open-source/clojure/comfykafka/target/js/compiled/comfykafka.js"

# Kubernetes
alias k=kubectl
alias kns=kubens

# Database clients
# alias medis="pushd ~/work/open-source/js/medis && npm run start && popd"

# Editors
alias vim="emacsclient -c -a vim"
alias emacs-ssh="TERM=xterm-24bit emacs -nw"

# Chrome "apps"
alias outlook="google-chrome --profile-directory=Default --app-id=pkooggnaalmfkidjmlhoelhdllpphaga"

# Misc
alias i3lock="i3lock -c 000000" # Make i3lock black
alias dbeaver-custom="sudo dbeaver-ce -vmargs -Xmx8192m"
alias google-chrome="google-chrome-stable"
alias color-picker="cd ~/work/open-source/ColourPicker && python3 -m pick"
alias nord="nordvpn"
alias tf="terraform"
