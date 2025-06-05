source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function prompt_my_tidelift_environment() {
  p10k segment -f '#f6914d' -i 'T' -t "${TIDELIFT_ENVIRONMENT}"
}

# prepend
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(my_tidelift_environment "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}")
POWERLEVEL9K_MY_TIDELIFT_ENVIRONMENT_SHOW_ON_COMMAND='tl'

POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='N'
POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_BACKGROUND=31
POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND=0
POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='N'
POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_BACKGROUND=31
POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=0

# Show duration of the last command if takes at least this many seconds.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0

# Show this many fractional digits. Zero means round to seconds.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1

# Duration format: 1d 2h 3m 4s.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
