source "$HOME/zshrc/init.zsh"

# Load the remaining config files
autorun_files=($(find $HOME/zshrc/ -type f -name '*.zsh' ! -name 'init.zsh'))
for file in ${autorun_files}; do
  # echo $file
  source $file
done

