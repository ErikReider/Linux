setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef

# Remove paste highlight
# zle_highlight=('paste:none')

export ZDOTDIR="$HOME/zsh"

source $ZDOTDIR/zsh-functions

zsh_add_file "zsh-exports"
zsh_add_file "zsh-alias"
zsh_add_file "zsh-bindings"
zsh_add_file "zsh-completions"
zsh_add_file "zsh-prompt"
zsh_add_file "zsh-git-bindings"

# Plugins
zsh_add_plugin "plugins/zsh-autosuggestions"
zsh_add_plugin "plugins/zsh-syntax-highlighting"
zsh_add_plugin "plugins/zsh-history-substring-search"
# Plugin Configs
zsh_add_file "plugin-conf/zsh-autosuggestions"
zsh_add_file "plugin-conf/zsh-syntax-highlighting"
zsh_add_file "plugin-conf/zsh-history-substring-search"

