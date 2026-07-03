# --- wi -> wezterm imgcat: render an image inline in the terminal ---
# Guarded: the wezterm CLI is absent on the Sherlock login host, so only define
# the alias where it exists (keeps the config degrading gracefully elsewhere).
# Usage: wi path/to/image.png
if command -v wezterm >/dev/null 2>&1; then
  alias wi='wezterm imgcat'
fi
