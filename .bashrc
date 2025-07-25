#!/usr/bin/env bash

# Set default apps
export BROWSER=firefox
export EDITOR="emacsclient -c -a nvim"

# --- Sane defaults ---
# append to the history file, don't overwrite it
shopt -s histappend
# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=2000000
# Only show the last 3 directories
export PROMPT_DIRTRIM=3
# Make sure initial state is known
export PROMPT_COMMAND=""
# Support 24bit color for emacs tty
export COLORTERM=truecolor

# --- Set up paths ---
# Base paths
export PATH=~/.local/bin:$PATH
# Android studio stuff
if [ "$(uname)" == "Darwin" ]; then
    export ANDROID_HOME=~/Library/Android/sdk
    export PATH=~/Library/Android/sdk/platform-tools:$PATH
    export BASH_SILENCE_DEPRECATION_WARNING=1
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    export ANDROID_HOME=~/Android/Sdk
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi
# Emacs bootloader
export PATH=~/.emacs.default/bin:$PATH
export PATH=~/.emacs.d/bin:$PATH
export PATH=~/.config/emacs/bin:$PATH
# JS
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Mac + Python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# Rust
. "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

# Java
export LD_LIBRARY_PATH=LD_LIBRARY_PATH:/usr/lib/jvm/java-17-openjdk/lib/server/

# Clojure
export PATH="$PATH:$HOME/.babashka/bbin/bin"

# --- Load other shell scripts ---
# Autojump
# - Linux
[[ -s "${HOME}/.autojump/etc/profile.d/autojump.sh" ]] && source "${HOME}/.autojump/etc/profile.d/autojump.sh"
# - Mac
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Keychain
# Don't have to enter passphrases all the time. See https://stackoverflow.com/a/42165501
type keychain >&/dev/null && keychain -q --agents ssh >&/dev/null
[ -f "${HOME}/.keychain/$HOSTNAME-sh" ] && source "${HOME}/.keychain/$HOSTNAME-sh"

# Prevent being asked for SSH passphrases all the time
eval $(ssh-agent -s) >> /dev/null

# JS
export NVS_HOME="$HOME/.nvs"
[ -s "${NVS_HOME}/nvs.sh" ] && . "${NVS_HOME}/nvs.sh" > /dev/null

# Aliases, etc
if [ -f ~/.bash_aliases ]; then . "${HOME}/.bash_aliases"; fi
if [ -f ~/.bash_env_vars ]; then . "${HOME}/.bash_env_vars"; fi
if [ -f ~/.bash_completions ]; then . "${HOME}/.bash_completions"; fi
if [ -f ~/.bash_utils ]; then . "${HOME}/.bash_utils"; fi
if [ -f ~/.bash_private ]; then . "${HOME}/.bash_private"; fi

# Completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# --- Emacs setup ---
# LSP
export LSP_USE_PLISTS=true
# shell-mode
if [[ $INSIDE_EMACS =~ ^.*comint ]]; then
    ps1() {
      # Borrowed from
      CURRENT_DIR='\w'
      PROMPT_COLOR='\e[1;33m'
      DOLLAR_SIGN_COLOR='\e[1;35m'
      COLOR_RESET='\033[0m'
      PS1="\n${PROMPT_COLOR}${CURRENT_DIR} ${DOLLAR_SIGN_COLOR}\$${COLOR_RESET} "
    }
    ps1;
    # Don't do the rest of what's in this script
    # to make sure shell-mode doesn't lag
    return 0;
fi;

# This is a command to help debug a frozen emacs
alias unfreeze_emacs="ps aux | grep -ie emacs | grep -v grep | awk '{print $2}' | xargs kill -SIGUSR2"

# --- Appearance ---
[ -f "${HOME}/.bash-powerline.sh" ] && source "${HOME}/.bash-powerline.sh"

# --- History ---
# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
function hstrnotiocsti {
    { READLINE_LINE="$( { </dev/tty hstr ${READLINE_LINE}; } 2>&1 1>&3 3>&- )"; } 3>&1;
    READLINE_POINT=${#READLINE_LINE}
}
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind -x '"\C-r": "hstrnotiocsti"'; fi
export HSTR_TIOCSTI=n

# (only for Mac) Fix missing system libs in path
if [ "$(uname)" == "Darwin" ]; then
  export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
  export LIBRARY_PATH="$LIBRARY_PATH:$SDKROOT/usr/lib"
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SDKROOT/usr/lib"
  export PATH="$PATH:$SDKROOT/usr/lib"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

