# forgit — print a cheatsheet of the forgit (fzf-powered git) aliases.
# The forgit plugin (~/.local/share/forgit) provides no bare `forgit` command,
# only `forgit::*` helpers behind these aliases, so this name is free to reuse.
forgit() {
  local -a rows=(
    "ga|Interactive git add selector"
    "gd|Interactive git diff viewer"
    "gi|Interactive .gitignore generator"
    "glo|Interactive git log viewer"
    "gso|Interactive git show viewer — see what's about to be committed"
    "grh|Interactive git reset HEAD <file> selector"
    "grs|Interactive git restore <file> selector"
  )
  print -P "%F{cyan}%B❯ forgit%b%f %F{244}— interactive git via fzf%f"
  print
  local row cmd desc
  for row in $rows; do
    cmd=${row%%|*}
    desc=${row#*|}
    print -P "  %F{green}%B${(r:5:)cmd}%b%f${desc}"
  done
}
