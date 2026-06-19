funchion lsg () {
  # see the git status and tree at the same time
  local LEVEL="${1:-1}"
  eza -lR -L $LEVEL --git
}
