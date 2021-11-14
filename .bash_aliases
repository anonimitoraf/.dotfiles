# Filesystem
alias ll='exa -l'
alias la='exa -la'
alias lt='exa -lT'
alias lg='exa -lT --git'

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

# Chrome "apps"
alias outlook="google-chrome --profile-directory=Default --app-id=pkooggnaalmfkidjmlhoelhdllpphaga"

# Misc
alias i3lock="i3lock -c 000000" # Make i3lock black
alias dbeaver-custom="sudo dbeaver-ce -vmargs -Xmx8192m"
