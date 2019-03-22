# ls
alias ll='exa -l'
alias la='exa -la'
alias lt='exa -lT'
alias lg='exa -lT --git'
alias l='ls -CF'

alias _shd='shutdown -h now'

# commonly used tools
alias fs="thunar ."
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias t=tmux
alias g=grep
alias ht=htop
alias h='hoogle --count=5'
alias v=vim
alias a=atril
alias s=source
alias c=clear

# haskell
alias ghci-auto="ghcid '--command=stack ghci' --test=main"

# books I'm currently reading
alias lyahftgg="atril ~/programming-misc/books/haskell/lyahftgg.pdf"
