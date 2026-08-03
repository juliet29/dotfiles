# Usage: ki path/to/image.png  — display an image inline via kitty's icat.
#
# Rendering/appearance still comes entirely from the LOCAL kitty config on the
# client; this only resolves the helper binary that draws over the connection.
# Resolution order:
#   1. `kitten` on PATH — the standalone binary (on Sherlock it lives in
#      ~/.local/bin/kitten, a statically-linked build that runs on old glibc;
#      install with: curl -fL -o ~/.local/bin/kitten \
#        https://github.com/kovidgoyal/kitty/releases/latest/download/kitten-linux-amd64 && chmod +x ~/.local/bin/kitten
#   2. `kitty` on PATH — full app (desktops where kitty itself is installed).
# The old `kitty icat` form is kept only as the #2 fallback; `kitten icat` is
# the modern spelling and what the standalone binary expects.
# NOTE: this file is sourced early (the ~/.config/zsh/functions/*.zsh loop),
# BEFORE .zshrc prepends ~/.local/bin to PATH, so `command -v kitten` can't be
# relied on here — check the known install path explicitly (order-independent).
if command -v kitten >/dev/null 2>&1; then
  alias ki='kitten icat'
elif [[ -x "$HOME/.local/bin/kitten" ]]; then
  alias ki="$HOME/.local/bin/kitten icat"
elif command -v kitty >/dev/null 2>&1; then
  alias ki='kitty icat'
fi
