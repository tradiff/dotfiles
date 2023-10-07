# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

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

autoload -Uz compinit && compinit

zstyle ':completion:*' menu select

set-window-title() {
  window_title="\e]0;${${PWD/#"$HOME"/~}##*/}\a"
  echo -ne "$window_title"
}

autoload -U add-zsh-hook
set-window-title
add-zsh-hook precmd set-window-title

# add ~/bin to PATH
export PATH="$PATH:$HOME/bin"
# add ~/go/bin to PATH
export PATH="$PATH:$HOME/go/bin"

alias ls='ls -lGFhva'
alias cls='clear && printf "\e[3J"'
alias k="kubectl"
alias g="git"
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

. /opt/homebrew/opt/asdf/libexec/asdf.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/projects/infra/tidelift.sh
tl setenv awsprod

# returns the number of minutes remaining in the current sso session
tl-lremaining() {
  aws configure get sso_start_url --profile ${AWS_PROFILE} | xargs -I {} grep -h {} ~/.aws/sso/cache/*.json | jq .expiresAt | xargs -I {} zsh -c 'echo $(( ( $(gdate -d "{}" +'%s') - $(gdate +'%s') ) / 60 ))'
}

# tl login if needed
tl-l() {
  remaining_minutes=$(tl-lremaining)

  if [[ $remaining_minutes -lt 10 ]]; then
    tl login
    remaining_minutes=$(tl-lremaining)
  fi
  echo "Remaining minutes: $remaining_minutes"
}

tl-console() { tl-l; tl ci-console }
tl-db() { tl-l; tl pg-ro datagrip }
tl-db-primary() { tl-l; tl pg-primary datagrip }
tl-k9s() { tl-l; k9s }

export GIT_COMPLETION_CHECKOUT_NO_GUESS=1

source ~/secrets.zsh
