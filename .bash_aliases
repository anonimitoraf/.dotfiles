# Filesystem
alias ll='exa -l'
alias la='exa -la'
alias lt='exa -lT'
alias lg='exa -lT --git'

alias fs="thunar ."
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# Haskell
alias ghci-auto="ghcid '--command=stack ghci' --test=main"
alias h='hoogle --count=5'

# Kubernetes
alias k=kubectl
alias kns=kubens

# Database clients
alias medis="pushd ~/work/open-source/js/medis && npm run start && popd"

# Editors
alias vim="emacsclient -c -a vim"

# Misc
alias i3lock="i3lock -c 000000" # Make i3lock black
