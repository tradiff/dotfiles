function __bell_on_command_done --on-event fish_postexec
	if test "$CMD_DURATION" -gt 1000
		printf '\a'
	end
end
