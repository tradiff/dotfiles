# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

case `uname` in
  Darwin)
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
    source /opt/homebrew/opt/asdf/libexec/asdf.sh
  ;;
  Linux)
    source ~/powerlevel10k/powerlevel10k.zsh-theme
    eval "$(rbenv init - zsh)"
    source /usr/share/nvm/init-nvm.sh
  ;;
esac

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

set-title-from-cwd() {
  cwd_title="${${PWD/#"$HOME"/~}##*/}"
  set-title $cwd_title
}

set-title() {
  echo -ne "\e]0;$1\a"; 
}

export DISABLE_AUTO_TITLE=true
autoload -U add-zsh-hook
add-zsh-hook precmd set-title-from-cwd

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"

alias ls='exa -lha -F=always --git --group-directories-first'
alias cls='clear && printf "\e[3J"'
alias k="kubectl"
alias g="git"
alias rspecp='bundle exec turbo_tests'
alias db-up='rails db:migrate'
alias db-down='rails db:rollback STEP=1'
alias db-redo='rails db:migrate:redo'
alias db-status='rails db:migrate:status'

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


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GIT_COMPLETION_CHECKOUT_NO_GUESS=1

source ~/secrets.zsh
source ~/.zshrc-tl

