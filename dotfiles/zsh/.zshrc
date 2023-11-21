setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef

export ZDOTDIR="$HOME/zsh"

# If ZSH is not defined, use the current script's directory.
[[ -z "$ZSH" ]] && export ZSH="${${(%):-%x}:a:h}"

# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZSH/cache"
fi

# Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
if [[ ! -w "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
fi

# Create cache and completions dir and add to $fpath
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

if ! [ -f "$ZDOTDIR/antigen.zsh" ]; then
    # Install Antigen ZSH plugin manager if not installed
    curl -L git.io/antigen >"$ZDOTDIR/antigen.zsh"
fi

source "$ZDOTDIR/antigen.zsh"

source "$ZDOTDIR/zsh-functions"
source "$ZDOTDIR/zsh-exports"
source "$ZDOTDIR/zsh-alias"
source "$ZDOTDIR/zsh-bindings"
source "$ZDOTDIR/zsh-completions"
source "$ZDOTDIR/zsh-prompt"

# Plugins
antigen bundle zsh-interactive-cd
antigen bundle command-not-found

antigen bundle git
antigen bundle docker-compose
antigen bundle docker
antigen bundle asdf
antigen bundle zsh-cargo-completion

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply

# Plugin config
source "$ZDOTDIR/plugin-conf/zsh-autosuggestions"
source "$ZDOTDIR/plugin-conf/zsh-history-substring-search"
