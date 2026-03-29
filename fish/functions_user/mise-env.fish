# Select and manage MISE_ENV using fzf.
# Presents all envs scraped from `.mise.*.local.toml` files in the current dir and parents.
# Sets MISE_ENV or unsets it based on selection.
function mise-env
    set -l unset_value __MISE_ENV_UNSET__
    set -l files

    set -l dir (pwd)
    while true
        for f in $dir/.mise.*.local.toml
            if test -f $f
                set files $files (string replace --regex '.*/\.mise\.(.+)\.local.toml$' '$1' $f)
            end
        end

        if test "$dir" = "/"
            break
        end

        set dir (dirname $dir)
    end

    set -l unset_option (set_color normal)"── unset ── "(set_color brblack)"(disable)"(set_color normal)
    set -l sorted_files (printf '%s\n' $files | sort -u)

    set -l selected (
        begin
            printf '%s\t%s\n' $unset_value $unset_option
            for file in $sorted_files
                printf '%s\t%s\n' $file $file
            end
        end | fzf \
        --ansi \
        --delimiter='\t' \
        # display second value
        --with-nth=2 \
        # return first value
        --accept-nth=1 \
        --prompt="Env ❯ " \
        --header="Select mise env • Enter=set • Esc=cancel • unset=disable" \
        --border \
        --border-label=" mise env " \
        --padding=1 \
        --margin=5%,10% \
        --layout=reverse \
        --height=40%)

    if test -n "$selected"
        if test "$selected" = "$unset_value"
            set -ge MISE_ENV
            echo "Unset MISE_ENV"
        else
            set -gx MISE_ENV $selected
            echo "Set MISE_ENV=$MISE_ENV"
        end
    end
end
