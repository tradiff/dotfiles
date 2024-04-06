local profile_zsh="false"

report_timing() {
  if [[ $profile_zsh == "true" ]]; then
    local label=$1
    local start_time=$2
    local end_time=$3
    local elapsed_time=$(printf "%.2f" $((($end_time - $start_time) * 1000.0)))
    echo "$label: ${elapsed_time}ms"
  fi
}

# Load init.zsh
source "$HOME/zshrc/init.zsh"

local zsh_start_time=$EPOCHREALTIME

# Load the remaining config files
autorun_files=($(find $HOME/zshrc/ -type f -name '*.zsh' ! -name 'init.zsh'))
for file in ${autorun_files}; do
  file_start_time=$EPOCHREALTIME
  source $file
  file_end_time=$EPOCHREALTIME
  report_timing $file $file_start_time $file_end_time
done

local zsh_end_time=$EPOCHREALTIME
report_timing "zsh" $zsh_start_time $zsh_end_time

