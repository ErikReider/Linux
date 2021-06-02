#!/bin/zsh

# Checks if working tree is dirty
function git_prompt_info() {
    local color="green"
    local sep=""
    gitBranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ "$gitBranch" != "" ]]; then
        if [[ "$(git status 2>/dev/null | grep 'modified:' | wc -l)" > "0" ]]; then
            local mod="%{$fg_bold[yellow]%}*"
            color="red"
            sep=" "
        fi
        if [[ "$(git status 2>/dev/null | grep 'Untracked files:' | wc -l)" != "0" ]]; then
            local untr="%{$fg_bold[yellow]%}±"
            color="red"
            sep=" "
        fi
        echo "%{$fg_bold[$color]%}[${untr}${mod}${sep}%{$fg_bold[$color]%}$gitBranch]"
    fi
}

