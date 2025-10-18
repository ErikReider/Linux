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

#
# Config
#

source "$ZDOTDIR/zsh-functions"
source "$ZDOTDIR/zsh-exports"
source "$ZDOTDIR/zsh-alias"
source "$ZDOTDIR/zsh-bindings"
source "$ZDOTDIR/zsh-completions"
source "$ZDOTDIR/zsh-prompt"

#
# Plugin Manager
#

# Install Antidote ZSH plugin manager if not installed
[[ -e "${ZDOTDIR:-~}/.antidote" ]] ||
    git clone --depth=1 https://github.com/mattmc3/antidote.git "${ZDOTDIR:-~}/.antidote"
# Source antidote
source "${ZDOTDIR:-~}/.antidote/antidote.zsh"

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=("$ZDOTDIR/.antidote/functions" $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi
# Source your static plugins file.
source ${zsh_plugins}.zsh

#
# Plugin config
#

source "$ZDOTDIR/plugin-conf/zsh-autosuggestions"
source "$ZDOTDIR/plugin-conf/zsh-history-substring-search"
