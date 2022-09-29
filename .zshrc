fpath=(~/.zsh $fpath)

autoload -Uz compinit -i && compinit -i
autoload -Uz bashcompinit && bashcompinit

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%b'
 
autoload -U colors && colors

function is_git_repo {
    git rev-parse 2>/dev/null; [ $? -eq 0 ] 
}

function is_dirty_repo {
    is_git_repo && [[ -n $(git status -s) ]]
}

function git_string {
    echo $(is_git_repo && echo "%{$fg[blue]%} ${vcs_info_msg_0_}")%F{$(is_dirty_repo && echo "214" || echo "82")} "> %{$reset_color%}"
}

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%{$fg[magenta]%}${PWD/#$HOME/~}$(git_string)'

source ~/.bash_profile
