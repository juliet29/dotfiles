# tmux session navigator (tmux + fzf, no sesh dependency)
tc() {
  local cp_mocha=(
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  )

  # require a reachable tmux server up front; never start a new one.
  # if the connection to the host's tmux server fails, error out here.
  local sessions
  if ! sessions=$(tmux list-sessions -F '#{session_name}' 2>&1); then
    echo "tc: cannot reach tmux server: ${sessions}" >&2
    return 1
  fi

  # pick an existing session; --print-query lets you type a new name to create one
  local result
  result=$(print -r -- "$sessions" | fzf "${cp_mocha[@]}" \
    --height 40% \
    --reverse \
    --border=rounded \
    --border-label=" ⚡ TMUX NAVIGATOR " \
    --prompt="✨ Switch Session: " \
    --print-query)

  # line 1 = typed query, line 2 = highlighted match (empty if no match chosen)
  local -a lines=("${(@f)result}")
  local target="${lines[2]:-${lines[1]}}"
  [ -z "$target" ] && { echo "Selection cancelled."; return; }

  # the server is confirmed reachable above, so any new-session here only ever
  # adds a session to the existing server -- it can never start a new server.
  if [ -n "$TMUX" ]; then
    # already inside tmux -> switch (attach is refused when nested)
    tmux switch-client -t "$target" 2>/dev/null \
      || { tmux new-session -ds "$target" && tmux switch-client -t "$target"; }
  else
    # outside tmux -> attach, creating the session if it doesn't exist
    tmux attach -t "$target" 2>/dev/null \
      || tmux new-session -s "$target"
  fi
}
