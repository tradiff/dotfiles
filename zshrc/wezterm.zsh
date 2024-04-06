set-title-from-cwd() {
  cwd_title="${${PWD/#"$HOME"/~}##*/}"
  set-title $cwd_title
}

set-title() {
  echo -ne "\e]0;$1\a"; 
}

export DISABLE_AUTO_TITLE=true
