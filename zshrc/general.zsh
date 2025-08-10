setopt autocd
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
HISTDUP=erase

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # Up arrow
bindkey "^[[B" down-line-or-beginning-search # Down arrow

# don't highlight text after pasting it
zle_highlight=('paste:none')

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# partial completion suggestions
zstyle ':completion:*' list-suffixeszstyle ':completion:*' expand prefix suffix

autoload -Uz compinit && compinit

autoload -U add-zsh-hook
add-zsh-hook precmd set-title-from-cwd

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/sbin"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$MAVEN_HOME/bin
export PATH="$PATH:/opt/gradle/gradle-8.9/bin"
export PATH="$PATH:/home/travis/Applications/idea-IU-243.24978.46/bin"
export MAVEN_HOME=/opt/maven

alias ls='eza -lha -F=always --git --group-directories-first'
alias cls='clear && printf "\e[3J"'
alias k="kubectl"
alias zy="sudo zypper"
alias dnf="sudo dnf"
alias mr="mise run"

function lc() {
    if [ -d "$1" ]; then
        ls "$1"
    elif [ -f "$1" ]; then
        cat "$1"
    else
        echo "File or directory does not exist"
    fi
}

export WORKER_TIMEOUT=3600

export EDITOR="nvim"
export DIFFPROG="nvim -d $1"

bindkey "^[[1~" beginning-of-line # home
bindkey "^[[4~" end-of-line       # end
bindkey "^[[1;5C" forward-word    # ctrl + right
bindkey "^[[1;5D" backward-word   # ctrl + left
bindkey "^[" kill-whole-line      # esc
bindkey "\C-?" backward-delete-char
bindkey "\C-h" backward-kill-word
bindkey "[3~" delete-char # Delete

# ctrl+z to toggle between open text editors
bindkey -s '^Z' '^Ufg^M'

source ~/secrets.sh
