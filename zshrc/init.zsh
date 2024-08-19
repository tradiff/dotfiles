source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function prompt_my_tidelift_environment() {
  p10k segment -f '#f6914d' -i 'T' -t "${TIDELIFT_ENVIRONMENT}"
}

# prepend
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(my_tidelift_environment "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}")
POWERLEVEL9K_MY_TIDELIFT_ENVIRONMENT_SHOW_ON_COMMAND='tl'

