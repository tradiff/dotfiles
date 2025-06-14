file="$HOME/projects/infra/tidelift.sh"

if [[ -f "$file" ]]; then
  source $file
fi

# returns the number of minutes remaining in the current sso session
tl-lremaining() {
  # aws configure get sso_start_url --profile ${AWS_PROFILE} | xargs -I {} grep -h {} ~/.aws/sso/cache/*.json | jq .expiresAt | xargs -I {} zsh -c 'echo $(( ( $(date -d "{}" +'%s') - $(date +'%s') ) / 60 ))'
  aws configure get sso_start_url --profile ${AWS_PROFILE} | xargs -I {} grep -h {} ~/.aws/sso/cache/*.json | jq .expiresAt | xargs -I {} zsh -c 'echo $(( ( $(date -d "{}" +'%s') - $(date +'%s') ) / 60 ))'
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

tl-console() { set-title "$0"; tl-l; tl ci-console }
tl-db() { set-title "$0"; tl-l; tl pg-ro datagrip }
tl-db-primary() { set-title "$0"; tl-l; tl pg-primary datagrip }
tl-k9s() { set-title "$0"; tl-l; k9s }

export DD_TRACE_STARTUP_LOGS=false
export TIDELIFT_CI_CONSOLE_IRBRC=$HOME/projects/dependencyci/.irbrc.prod.rb
