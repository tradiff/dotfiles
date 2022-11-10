# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt autocd
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

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

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit

zstyle ':completion:*' menu select

set-window-title() {
  window_title="\e]0;${${PWD/#"$HOME"/~}##*/}\a"
  echo -ne "$window_title"
}

set-window-title
add-zsh-hook precmd set-window-title

# add ~/bin to PATH
export PATH="$PATH:$HOME/bin"

alias ls='ls -lGFhva'
alias cls='clear && printf "\e[3J"'

# delete any branches that have been pushed and then deleted upstream
git-prune() {
  git switch main
  git fetch -p
  git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}

alias k="kubectl"
alias rspecp='bundle exec turbo_tests'
alias db-up='rails db:migrate'
alias db-down='rails db:rollback STEP=1'
alias db-redo='rails db:migrate:redo'
alias db-status='rails db:migrate:status'


slack-status() {
  # $1 = emoji (:hamburger:)
  # $2 = status message ("out to lunch")
  # $3 = presence (away/auto)
  curl -X POST -H "Authorization: $SLACK_AUTH_HEADER" \
    -H 'Content-type: application/json' \
    --data "{
      \"profile\": {
        \"status_emoji\": \"$1\",
        \"status_text\": \"$2\",
        \"status_expiration\": 0
      }
    }" \
    https://slack.com/api/users.profile.set

  curl -X POST -H "Authorization: $SLACK_AUTH_HEADER" \
    -H 'Content-type: application/json' \
    --data "{\"presence\": \"$3\"}" \
    https://slack.com/api/users.setPresence
}

lunch() {
  slack-status ":hamburger:" "out to lunch" "away"
}

afk() {
  slack-status ":afk:" "afk" "away"
}

back() {
  slack-status "" "" "auto"
}

export WORKER_TIMEOUT=3600

export EDITOR="code -w"

# iterm2
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# tmux
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

bindkey "^[" kill-whole-line

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/projects/infra/tidelift.sh
tl setenv awsprod

source ~/secrets.zsh
