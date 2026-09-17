#!/usr/bin/env bash

# Render a Powerlevel10k-inspired path for Starship. Append the Git branch unless it is already
# the worktree-root path segment; then keep that segment unshortened and render it in branch color.

dim=$'\033[38;5;31m'
shortened=$'\033[38;5;103m'
highlight=$'\033[1;38;5;39m'
git_branch_color=$'\033[1;35m'
separator=$'\033[38;2;51;51;51m'
reset=$'\033[0m'
max_path_length=40

# Marker files keep their directory segment visible, as in Powerlevel10k.
markers=(
    .bzr .citc .git .hg .node-version .python-version .go-version .ruby-version
    .lua-version .java-version .perl-version .php-version .tool-versions .mise.toml
    .shorten_folder_marker .svn .terraform CVS Cargo.toml composer.json go.mod package.json
    stack.yaml
)

has_marker() {
    # Return true when the directory is a Powerlevel10k anchor.
    local marker
    for marker in "${markers[@]}"; do
        [[ -e $1/$marker || -L $1/$marker ]] && return 0
    done
    return 1
}

shortest_unique_prefix() {
    # Print the shortest prefix that identifies this directory among its siblings.
    local parent=$1 name=$2 child prefix
    local -i length=${#name} prefix_length=0 matches

    while [[ ${name:prefix_length:1} == . ]]; do
        ((prefix_length++))
    done

    while (( prefix_length < length )); do
        ((prefix_length++))
        prefix=${name:0:prefix_length}
        matches=0
        for child in "$parent"/"$prefix"*; do
            [[ -d $child ]] || continue
            ((++matches == 2)) && break
        done
        (( matches == 1 )) && break
    done

    printf '%s' "${name:0:prefix_length}"
}

is_worktree_branch() {
    # Match the literal branch name or Worktrunk's slash-to-hyphen directory name.
    [[ $1 == "$2" || $1 == "${2//\//-}" ]]
}

render_path() {
    # Color and shorten path segments, replacing a branch-root directory with its branch label.
    local path=$1 root=$2 worktree_marker=$3
    local current component prefix display_prefix=
    local -a parts actual_parts display_parts anchors branches rendered_parts
    local -i i last length required emitted

    if [[ $path == "$HOME" || $path == "$HOME"/* ]]; then
        actual_parts=("$HOME")
        display_parts=('~')
        current=$HOME
        path=${path#"$HOME"}
        path=${path#/}
    elif [[ $path == / ]]; then
        printf '%s' "${dim}/${reset}"
        return
    else
        current=
        path=${path#/}
        display_prefix=/
    fi

    IFS=/ read -r -a parts <<< "$path"
    for component in "${parts[@]}"; do
        [[ -n $component ]] || continue
        if [[ -n $current ]]; then
            current=$current/$component
        else
            current=/$component
        fi
        actual_parts+=("$current")
        display_parts+=("$component")
    done

    last=$((${#actual_parts[@]} - 1))
    length=${#display_prefix}

    for ((i = 0; i <= last; i++)); do
        if [[ $worktree_marker == true && ${actual_parts[i]} == "$root" ]]; then
            (( i > 0 )) && ((length++))
            ((length += ${#display_parts[i]} + 2))
            branches[i]=1
            continue
        fi

        (( i > 0 )) && ((length++))
        ((length += ${#display_parts[i]}))

        if (( i == 0 || i == last )) || has_marker "${actual_parts[i]}"; then
            anchors[i]=1
        fi
    done

    # Shorten eligible segments from left to right once the rendered path exceeds 40 columns.
    required=$((length - max_path_length))
    for ((i = 0; i <= last && required > 0; i++)); do
        [[ -n ${anchors[i]} || -n ${branches[i]} ]] && continue
        prefix=$(shortest_unique_prefix "$(dirname "${actual_parts[i]}")" "${display_parts[i]}")
        (( ${#prefix} < ${#display_parts[i]} )) || continue
        rendered_parts[i]=$prefix
        ((required -= ${#display_parts[i]} - ${#prefix}))
    done

    printf '%s' "$dim$display_prefix"
    emitted=0
    for ((i = 0; i <= last; i++)); do
        if [[ -n ${branches[i]} ]]; then
            ((emitted++)) && printf '%s' "${dim}/${reset}"
            # A branch-root worktree shows its unshortened branch in place of the directory name.
            printf '%s' "${git_branch_color} ${display_parts[i]}${reset}"
            continue
        fi

        ((emitted++)) && printf '%s' "${dim}/${reset}"
        if [[ -n ${anchors[i]} ]]; then
            printf '%s' "${highlight}${display_parts[i]}${reset}"
        elif [[ -n ${rendered_parts[i]} ]]; then
            printf '%s' "${shortened}${rendered_parts[i]}${reset}"
        else
            printf '%s' "${dim}${display_parts[i]}${reset}"
        fi
    done
    printf '%s' "${dim}/${reset}"
}

self_test() {
    # Exercise path rules without requiring a Git repository.
    local temp long output
    temp=$(mktemp -d) || return 1
    trap 'rm -rf "$temp"' EXIT

    mkdir -p "$temp/alpha" "$temp/alpine" "$temp/beta"
    [[ $(shortest_unique_prefix "$temp" alpha) == alph ]]
    [[ $(shortest_unique_prefix "$temp" beta) == b ]]
    touch "$temp/alpha/.git"
    has_marker "$temp/alpha"
    is_worktree_branch alpha alpha
    is_worktree_branch feature-foo feature/foo
    ! is_worktree_branch other feature/foo

    printf -v long '%*s' 60 ''
    long=${long// /x}
    mkdir -p "$temp/$long/child"
    output=$(render_path "$temp/$long/child" '' false)
    [[ $output == *"${shortened}"* ]]

    output=$(render_path "$temp/alpha/child" "$temp/alpha" true)
    [[ $output == *"${dim}/${reset}${git_branch_color} alpha${reset}"* ]]
}

if [[ ${1-} == --test ]]; then
    self_test
    exit
fi

root=$(git rev-parse --show-toplevel 2>/dev/null)
path=$(pwd)
leaf=${root##*/}
branch=$(git branch --show-current 2>/dev/null)

if [[ -n $root ]]; then
    if is_worktree_branch "$leaf" "$branch"; then
        render_path "$path" "$root" true
    else
        render_path "$path" '' false
        [[ -n $branch ]] && printf '%s' " ${separator}|${reset} ${git_branch_color}${branch}${reset}"
    fi
else
    render_path "$path" '' false
fi

printf '%s' "$reset"
