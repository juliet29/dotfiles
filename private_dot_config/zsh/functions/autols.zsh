# Auto-list a directory when you cd into one that lives inside a git repo.
#
# chpwd is a zsh hook that runs after every directory change; add-zsh-hook
# appends ours to the list, so it coexists with zoxide's own chpwd hook rather
# than replacing it. We only list when inside a git work tree, so plain cd-ing
# around $HOME or / stays quiet.
#
# It calls `eza` directly (not the `ls` alias): this file is sourced before the
# `ls="eza --icons=always"` alias in .zshrc, and zsh expands aliases at
# function-definition time — so at definition `ls` wouldn't yet mean eza. Keep
# these flags in step with that alias.

autoload -Uz add-zsh-hook

_list_when_inside_a_repo() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    eza --icons=always
  fi
}

add-zsh-hook chpwd _list_when_inside_a_repo
