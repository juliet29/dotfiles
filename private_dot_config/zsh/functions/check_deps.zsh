# deps -> report which tools this shell config expects, and which are missing.
# Report-only: it never installs anything, just tells you what to grab.
# In the container you can install whatever's flagged; on the bare Sherlock
# host the config degrades gracefully without these.

deps() {
  # command -> where to get it
  local -A want=(
    eza        "https://github.com/eza-community/eza  (ls replacement)"
    zoxide     "https://github.com/ajeetdsouza/zoxide  (cd replacement)"
    fzf        "https://github.com/junegunn/fzf  (fuzzy finder)"
    fd         "https://github.com/sharkdp/fd  (fzf source; pkg: fd-find)"
    starship   "https://starship.rs  (prompt)"
    delta      "https://github.com/dandavison/delta  (chezmoi diffs)"
    nvim       "https://github.com/neovim/neovim  (editor)"
    direnv     "https://direnv.net  (per-dir env)"
    yazi       "https://github.com/sxyazi/yazi  (file manager)"
  )

  # file-based plugins (not on PATH) -> a representative path to check
  local -A files=(
    "zsh-autosuggestions"      "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "zsh-syntax-highlighting"  "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "forgit"                   "$HOME/.local/share/forgit/forgit.plugin.zsh"
    "fzf-tab"                  "$HOME/.local/share/fzf-tab/fzf-tab.plugin.zsh"
  )

  local -a missing=()
  local k

  print -P "%F{cyan}%B❯ commands%b%f"
  for k in ${(ko)want}; do
    if command -v "$k" >/dev/null 2>&1; then
      print -P "  %F{green}✔%f $k"
    else
      print -P "  %F{red}✗%f $k  %F{8}— ${want[$k]}%f"
      missing+=("$k")
    fi
  done

  print -P "%F{cyan}%B❯ plugins%b%f"
  for k in ${(ko)files}; do
    if [[ -f ${files[$k]} ]]; then
      print -P "  %F{green}✔%f $k"
    else
      print -P "  %F{red}✗%f $k  %F{8}— expected at ${files[$k]}%f"
      missing+=("$k")
    fi
  done

  if (( ${#missing} )); then
    print -P "%F{yellow}%B❯ ${#missing} missing:%b%f ${missing[*]}"
    return 1
  fi
  print -P "%F{green}%B✔ all present%b%f"
}
