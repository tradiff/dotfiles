function rspecp
    set start (date +%s)
    bundle exec turbo_tests -n10 --require ~/.config/ruby/rspec_formatter.rb --format RspecFormatter $argv
    set test_status $status
    set end (date +%s)
    set duration (math $end - $start)
    set minutes (math $duration / 60)
    set seconds (math $duration % 60)

    if test $test_status -eq 0
        notify-send --icon="messagebox_info" --app-name="turbo tests" --transient "tests passed 🎉" "in {$minutes}m {$seconds}s"
    else
        notify-send --icon="messagebox_critical" --app-name="turbo tests" --transient "tests failed" "in {$minutes}m {$seconds}s"
    end
    paplay ~/.config/dunst/gaming-lock.wav
end
