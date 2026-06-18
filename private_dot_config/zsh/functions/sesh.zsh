sc() {
  local cp_mocha=(
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  )

  local session=$(sesh list | fzf "${cp_mocha[@]}" \
    --height 40% \
    --reverse \
    --border=rounded \
    --border-label=" ⚡ SESH NAVIGATOR " \
    --prompt="✨ Connect Session: ")

  if [ -n "$session" ]; then
    sesh connect "$session"
  else
    echo "Selection cancelled."
  fi
}
