# -----------------------------
# Oh My Zsh
# -----------------------------

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-completions
  gradle-completion

  # use fzf for completion lists
  # keep this last so it wraps the final ^I binding
  fzf-tab
)


# -----------------------------
# Completion / fzf-tab
# -----------------------------

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colorize filenames
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Disable menu completion for fzf-tab
zstyle ':completion:*' menu no

# Use FZF_DEFAULT_OPTS for fzf-tab
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Preview directory contents with cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:git-*:*' fzf-flags --no-sort

zstyle ':completion:*:git-*:*' sort false
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-switch:*' sort false
zstyle ':completion:*:git-*:*' max-verbose -1
zstyle ':completion:*:git:*' group-order 'remote-branches' 'local-branches'

zstyle ':completion:*:git:*' sort-tags committerdate

# -----------------------------
# fzf
# -----------------------------

export FZF_DEFAULT_OPTS=" \
  --multi \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
"

# catppuccin-fzf-mocha
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

source "$ZSH/oh-my-zsh.sh"


# Prefer recently updated branches in zsh git completion.
# This overrides the stock `__git_branch_names`
# Same as the original, except with the addition of a sort
__git_branch_names() {
  local expl
  declare -a branch_names

  branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --sort=-committerdate --format='"%(refname)"' refs/heads 2>/dev/null)"}#refs/heads/})
  __git_command_successful $pipestatus || return 1

  __git_describe_commit branch_names branch-names 'branch name' "$@"
}

# Comment color was basically invisible by default. Override it.
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'


# -----------------------------
# Environment
# -----------------------------

export MAVEN_HOME=/opt/maven

# Preferred editor
export EDITOR="nvim"
export DIFFPROG="nvim -d"
export NVIM_APPNAME="nvim-lazy"


# -----------------------------
# PATH
# -----------------------------

typeset -U path PATH

extra_path=(
  "$HOME/.opencode/bin"
  "/home/travis/Applications/idea-IU-243.24978.46/bin"
  "/opt/gradle/gradle-8.9/bin"
  "$MAVEN_HOME/bin"
  "/usr/local/go/bin"
  "/usr/sbin"
  "$HOME/.local/bin"
  "$HOME/go/bin"
  "$HOME/bin"
)

path=(${^extra_path}(N-/) $path)


# -----------------------------
# Aliases
# -----------------------------

if command -v eza >/dev/null 2>&1; then
    alias ls='eza --long --all --classify=always --group-directories-first'
    alias tree='eza --tree --level=2 --all --classify=always --group-directories-first'
else
    alias ls='ls -lha --color=auto'
fi
alias cls='clear && printf "\e[3J"'
alias mr="mise run"
alias dnf="sudo dnf"

# -----------------------------
# Functions
# -----------------------------

function mise-env() {
  setopt local_options null_glob

  local unset_value="__MISE_ENV_UNSET__"
  local -a files sorted_files
  local dir="$PWD"
  local f unset_option selected

  while true; do
    for f in "$dir"/.mise.*.local.toml; do
      files+=("${f:t}")
      files[-1]="${files[-1]#.mise.}"
      files[-1]="${files[-1]%.local.toml}"
    done

    [[ "$dir" == "/" ]] && break
    dir="${dir:h}"
  done

  unset_option=$'── unset ── \e[90m(disable)\e[0m'
  sorted_files=("${(@ou)files}")

  selected=$(
    {
      printf "%s\t%s\n" "$unset_value" "$unset_option"
      for f in "${sorted_files[@]}"; do
        printf "%s\t%s\n" "$f" "$f"
      done
    } | fzf \
      --popup \
      --ansi \
      --delimiter="\t" \
      --with-nth=2 \
      --accept-nth=1 \
      --prompt="Env ❯ " \
      --header="Select mise env • Enter=set • Esc=cancel • unset=disable" \
      --border \
      --border-label=" mise env " \
      --layout=reverse
  )

  if [[ -n "$selected" ]]; then
    if [[ "$selected" == "$unset_value" ]]; then
      unset MISE_ENV
      echo "Unset MISE_ENV"
    else
      export MISE_ENV="$selected"
      echo "Set MISE_ENV=$MISE_ENV"
    fi
  fi
}

# -----------------------------
# Tool initialization
# -----------------------------

if [[ -f "$HOME/.atuin/bin/env" ]]; then
  source "$HOME/.atuin/bin/env"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# -----------------------------
# Keybindings / ZLE widgets
# -----------------------------

# clear screen *and* scrollback
function clear-scrollback() {
  clear && printf "\e[3J"
  zle reset-prompt
}
zle -N clear-scrollback
bindkey "^L" clear-scrollback # ctrl+L

function zle-line-init() {
  NUMERIC=1 zle set-local-history
}
zle -N zle-line-init


bindkey "^[" kill-whole-line # esc
bindkey "\C-h" backward-kill-word # ctrl+backspace

# open current command in EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^xe" edit-command-line # ctrl+x,e

# save current command in buffer & restore after next command is run
bindkey "^e" push-input # ctrl+e
