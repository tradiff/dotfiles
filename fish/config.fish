set --universal fish_greeting

################################################################################
# PATH configuration
################################################################################
set -gx PATH $PATH $HOME/bin
set -gx PATH $PATH $HOME/go/bin
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH /usr/sbin
set -gx PATH $PATH /usr/local/go/bin
set -gx PATH $PATH /opt/maven/bin
set -gx PATH $PATH /opt/gradle/gradle-8.9/bin
set -gx PATH $PATH /home/travis/Applications/idea-IU-243.24978.46/bin

################################################################################
# Environment variables
################################################################################
set -gx MAVEN_HOME /opt/maven
set -gx WORKER_TIMEOUT 3600
set -gx EDITOR nvim
set -gx DIFFPROG "nvim -d"

################################################################################
# Aliases
################################################################################
alias ls='eza -lha -F=always --git --group-directories-first'
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
# mise
################################################################################
~/.local/bin/mise activate fish | source

################################################################################
# Secrets
################################################################################
# if test -f ~/secrets.sh
#     source ~/secrets.sh
# end
