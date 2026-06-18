# git fetch -> status -> diffs (through delta, with fallback)
gfs() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repository."
    return 1
  fi

  # bold, colored section header so labels stand apart from git's output
  _gfs_head() { print -P "%F{cyan}%B❯ $1%b%f"; }

  # pipe through delta if available, otherwise use git's own colored diff
  _gfs_diff() {
    if command -v delta >/dev/null 2>&1; then
      git diff "$@" | delta -s
    else
      git diff "$@"
    fi
  }

  _gfs_head "Fetching"
  git fetch

  echo
  _gfs_head "Status"
  git status

  # higher priority: what the next commit will diverge from upstream
  echo
  if git rev-parse --symbolic-full-name @{u} >/dev/null 2>&1; then
    _gfs_head "Staged vs upstream (@{u})"
    _gfs_diff --staged @{u}
  else
    _gfs_head "Staged vs upstream"
    echo "No upstream configured for this branch."
  fi

  echo
  _gfs_head "Working tree vs staged"
  _gfs_diff

  unfunction _gfs_head _gfs_diff
}
