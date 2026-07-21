# pet — snippet manager (github.com/knqyf263/pet).
# Ctrl-S searches snippets via fzf and drops the chosen command onto the
# prompt for review/edit before you run it (never auto-executes).
# Ctrl-S is XOFF by default, so free it from terminal flow control first.
[[ -t 0 ]] && stty -ixon 2>/dev/null

pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N pet-select
bindkey '^s' pet-select
