setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef

export ZDOTDIR="$HOME/zsh"

if ! [ -f "$ZDOTDIR/antigen.zsh" ]; then
    # Install Antigen ZSH plugin manager if not installed
    curl -L git.io/antigen >"$ZDOTDIR/antigen.zsh"
fi

source "$ZDOTDIR/antigen.zsh"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Plugins
antigen bundle git
antigen bundle zsh-interactive-cd
antigen bundle command-not-found
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply

source "$ZDOTDIR/zsh-functions"
source "$ZDOTDIR/zsh-exports"
source "$ZDOTDIR/zsh-alias"
source "$ZDOTDIR/zsh-bindings"
source "$ZDOTDIR/zsh-completions"
source "$ZDOTDIR/zsh-prompt"

# Plugin config
source "$ZDOTDIR/plugin-conf/zsh-autosuggestions"
source "$ZDOTDIR/plugin-conf/zsh-history-substring-search"
