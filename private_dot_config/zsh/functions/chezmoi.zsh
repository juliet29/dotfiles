# chezmoi helpers — keep edits flowing through the source, not deployed files.

# Guard: opening a chezmoi-managed file in the editor redirects to its source,
# so you never hand-edit a deployed file (which `chezmoi apply` would overwrite).
nvim() {
  local f
  for f in "$@"; do
    [[ -e $f ]] || continue
    if chezmoi source-path "$f" >/dev/null 2>&1; then
      print -P "%F{yellow}⚠ ${f:t} is chezmoi-managed%f — editing its source via 'chezmoi edit --apply'."
      command chezmoi edit --apply "$f"
      return
    fi
  done
  command nvim "$@"
}

# ce  -> edit a managed file's source and re-apply on save
alias ce='chezmoi edit --apply'

# ccd -> jump to the chezmoi source repo in the current shell
ccd() { builtin cd "$(chezmoi source-path)"; }

# cez -> edit the actual .zshrc source partial for THIS machine, then re-apply.
# dot_zshrc.tmpl is only a selector; the real content lives in .zshrc.sherlock /
# .zshrc.default, chosen by the same rule the template uses.
cez() {
  local src file
  src="$(chezmoi source-path)" || return
  if [[ -n "$SHERLOCK" || "$(hostname -f 2>/dev/null)" == *.int ]]; then
    file="$src/.zshrc.sherlock"
  else
    file="$src/.zshrc.default"
  fi
  command nvim "$file" && chezmoi apply ~/.zshrc
}
