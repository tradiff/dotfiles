setopt autocd
setopt HIST_EXPIRE_DUPS_FIRST 
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt sharehistory
setopt hist_ignore_space

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
HISTDUP=erase

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up arrow
bindkey "^[[B" down-line-or-beginning-search # Down arrow

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

autoload -Uz compinit && compinit

zstyle ':completion:*' menu select

autoload -U add-zsh-hook
add-zsh-hook precmd set-title-from-cwd

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"

alias ls='eza -lha -F=always --git --group-directories-first'
alias cls='clear && printf "\e[3J"'
alias k="kubectl"

export WORKER_TIMEOUT=3600

export EDITOR="nvim"
export DIFFPROG="nvim -d $1"

# iterm2
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# tmux
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

bindkey "^[" kill-whole-line

source ~/secrets.zsh

