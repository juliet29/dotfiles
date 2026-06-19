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

# ca -> review pending changes (diff via delta), confirm, apply, then prune
# orphans. "Owned" dirs are ones chezmoi fully manages: any unmanaged file
# there is an orphan (e.g. a deployed copy left behind after a source rename).
ca() {
  local -a owned_dirs=(~/.config/zsh/functions)

  # gather managed changes + orphans up front
  local changes; changes=$(chezmoi status)
  local d line
  local -a orphans=()
  for d in $owned_dirs; do
    [[ -d $d ]] || continue
    while IFS= read -r line; do
      [[ -n $line ]] && orphans+=("$line")
    done < <(chezmoi unmanaged "$d")
  done

  if [[ -z $changes && ${#orphans} -eq 0 ]]; then
    print -P "%F{cyan}%B❯ Nothing to do%b%f"
    return
  fi

  # preview
  if [[ -n $changes ]]; then
    print -P "%F{cyan}%B❯ Pending changes%b%f"
    print -r -- "$changes"
    print -P "%F{cyan}%B❯ Diff%b%f"
    if command -v delta >/dev/null 2>&1; then
      chezmoi diff | delta -s
    else
      chezmoi diff
    fi
  fi
  if (( ${#orphans} )); then
    print -P "%F{yellow}%B❯ Orphans to prune%b%f"
    printf '  %s\n' "${orphans[@]}"
  fi

  # confirm before touching anything
  local reply
  read "reply?Proceed? [y/N] "
  [[ $reply == [Yy]* ]] || { print -P "%F{red}❯ aborted%f"; return 1; }

  # apply managed changes, then prune orphans
  [[ -n $changes ]] && { chezmoi apply || return }
  local orphan
  for orphan in "${orphans[@]}"; do
    print -P "%F{yellow}❯ pruning%f $orphan"
    rm -f -- "$HOME/$orphan"
  done

  print -P "%F{green}%B✔ done%b%f"
}
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


# see diffs
cdi() { chezmoi diff | delta -s && "Either had chezmoi diffs or didnt" }
