eval "$(rbenv init - zsh)"

function rspecp {
    local start=$(date +%s)
    bundle exec turbo_tests -n10 --require ~/.config/ruby/rspec_formatter.rb --format RspecFormatter "$@"
    local test_status=$?
    local end=$(date +%s)
    local duration=$((end - start))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    if [ $test_status -eq 0 ]; then
      notify-send --icon="messagebox_info" --app-name="turbo tests" --transient "tests passed 🎉" "in ${minutes}m ${seconds}s"

    else
        notify-send --icon="messagebox_critical" --app-name="turbo tests" --transient "tests failed" "in ${minutes}m ${seconds}s"
    fi
    paplay ~/.config/dunst/gaming-lock.wav
}

alias db-up='rails db:migrate'
alias db-down='rails db:rollback STEP=1'
alias db-redo='rails db:migrate:redo'
alias db-status='rails db:migrate:status'
