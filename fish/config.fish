set --universal fish_greeting

################################################################################
# PATH configuration
################################################################################
fish_add_path $HOME/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.local/bin
fish_add_path /usr/sbin
fish_add_path /usr/local/go/bin
fish_add_path /opt/maven/bin
fish_add_path /opt/gradle/gradle-8.9/bin
fish_add_path /home/travis/Applications/idea-IU-243.24978.46/bin
fish_add_path /home/travis/.opencode/bin

################################################################################
# Environment variables
################################################################################
set -gx MAVEN_HOME /opt/maven
set -gx WORKER_TIMEOUT 3600
set -gx EDITOR nvim
set -gx DIFFPROG "nvim -d"
set -gx NVIM_APPNAME nvim-lazy
set -gx NODE_TLS_REJECT_UNAUTHORIZED 0

################################################################################
# Aliases
################################################################################
if command -v eza > /dev/null
    alias ls='eza -lha -F=always --git --group-directories-first'
else
    alias ls='ls -lha --color=auto'
end
alias cls='clear && printf "\e[3J"'
abbr --add k 'kubectl'
abbr --add dnf 'sudo dnf'
abbr --add mr 'mise run'

################################################################################
# Key binds
################################################################################
# Directory navigation with Ctrl+Arrows
bind \e\[1\;5D prevd-or-backward-word  # Ctrl+Left
bind \e\[1\;5C nextd-or-forward-word   # Ctrl+Right

# Clear screen with Ctrl+L
bind \cl 'cls; commandline -f repaint'

bind tab complete-and-search

################################################################################
# Atuin
################################################################################
if status --is-interactive
    atuin init fish  --disable-up-arrow | source
end

################################################################################
# User functions
################################################################################
set -p fish_function_path ~/.config/fish/functions_user

################################################################################
# mise
################################################################################
~/.local/bin/mise activate fish | source
