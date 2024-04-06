eval "$(rbenv init - zsh)"

alias rspecp='bundle exec turbo_tests'
alias db-up='rails db:migrate'
alias db-down='rails db:rollback STEP=1'
alias db-redo='rails db:migrate:redo'
alias db-status='rails db:migrate:status'
