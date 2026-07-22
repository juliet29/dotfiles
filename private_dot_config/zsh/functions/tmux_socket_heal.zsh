# Self-heal a reaped tmux socket.
#
# Sherlock's node-local /tmp gets reaped (tmpwatch/systemd-tmpfiles). If the
# socket file for a STILL-RUNNING server is deleted, the pane you're attached to
# keeps working (it holds an open fd), but every NEW connection fails -- e.g. the
# client-detached `tmuxp-sync save` hook and the client-attached breadcrumb hook
# can no longer reach the server. tmux recreates its socket on SIGUSR1, so on
# each prompt: if we're inside tmux but the socket path is gone, signal the
# server to remake it.
#
# $TMUX = "<socket_path>,<server_pid>,<session_id>". Cheap: one stat + maybe one
# kill, only when the file is actually missing.
_tmux_socket_heal() {
  [[ -n "$TMUX" ]] || return 0
  local sock="${TMUX%%,*}"
  [[ -n "$sock" && ! -S "$sock" ]] || return 0
  local rest="${TMUX#*,}"
  local pid="${rest%%,*}"
  [[ "$pid" == <-> ]] || return 0
  kill -USR1 "$pid" 2>/dev/null
}
autoload -Uz add-zsh-hook 2>/dev/null && add-zsh-hook precmd _tmux_socket_heal
