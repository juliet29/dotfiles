# Usage: ki [icat-flags] path/to/image.png ...  — show image(s) inline via
# kitty's icat, printing a smart caption above each one.
#
# The caption answers "where is this, relative to where I'm standing?". For
# each file it compares two names and prints whichever is shorter:
#   - the path FROM the current directory TO the file  (e.g. assets/logo.png)
#   - the absolute path with $HOME shortened to '~'     (e.g. ~/proj/logo.png)
# So a nearby image reads like "assets/logo.png", while a distant one stays a
# tidy "~/proj/logo.png" instead of a long "../../../.." chain. The folder part
# is dimmed and the filename highlighted, in the spirit of timg's --title.
#
# Appearance of the image itself still comes entirely from the LOCAL kitty
# config on the client; this only resolves the helper binary that draws over
# the connection. Resolution order (checked at call time, PATH fully set up):
#   1. `kitten` on PATH — the standalone binary (on Sherlock it lives at
#      ~/.local/bin/kitten, a statically-linked build that runs on old glibc;
#      install with: curl -fL -o ~/.local/bin/kitten \
#        https://github.com/kovidgoyal/kitty/releases/latest/download/kitten-linux-amd64 && chmod +x ~/.local/bin/kitten
#   2. ~/.local/bin/kitten explicitly, in case PATH hasn't picked it up yet.
#   3. `kitty` on PATH — the full app; the old `kitty icat` form, as a fallback.

ki() {
  emulate -L zsh

  # 1. Find the binary that draws the image.
  local -a draw
  if command -v kitten >/dev/null 2>&1; then
    draw=(kitten icat)
  elif [[ -x "$HOME/.local/bin/kitten" ]]; then
    draw=("$HOME/.local/bin/kitten" icat)
  elif command -v kitty >/dev/null 2>&1; then
    draw=(kitty icat)
  else
    print -u2 -- "ki: no 'kitten' or 'kitty' binary found on PATH"
    return 127
  fi

  # 2. Sort the arguments: anything starting with '-' is a flag for icat,
  #    everything else is a file we want to show.
  local -a flags files
  local argument
  for argument in "$@"; do
    if [[ $argument == -* ]]; then
      flags+=("$argument")
    else
      files+=("$argument")
    fi
  done

  # No files (e.g. `ki --help`): hand the flags straight to icat and stop.
  if (( ${#files} == 0 )); then
    "${draw[@]}" "${flags[@]}"
    return
  fi

  # 3. Caption and draw each file.
  local file caption from_here from_home folder name
  for file in "${files[@]}"; do
    caption=$file
    if [[ -e $file ]]; then
      from_here=$(realpath --relative-to="$PWD" -- "$file" 2>/dev/null)
      from_home=${file:A}                  # :A  -> the absolute, real path
      from_home=${from_home/#$HOME/\~}     # /#  -> substitute only at the start
      if [[ -n $from_here && ${#from_here} -le ${#from_home} ]]; then
        caption=$from_here
      else
        caption=$from_home
      fi
    fi

    # Split "dir/sub/name.png" into a folder part and a filename part.
    folder=""
    name=$caption
    if [[ $caption == */* ]]; then
      folder=${caption%/*}/                # %/*  -> drop the last /segment
      name=${caption##*/}                  # ##*/ -> keep only after the last /
    fi

    print -P -- "%F{244}${folder}%f%B%F{cyan}${name}%f%b"
    "${draw[@]}" "${flags[@]}" "$file"
  done
}
