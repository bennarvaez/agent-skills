#!/usr/bin/env sh
# Installs the skills in this repo for Claude Code and GitHub Copilot (macOS / Linux).
#
# Links each folder in ./skills into:
#   ~/.agents/skills   (read by Copilot in VS Code and other agents)
#   ~/.claude/skills   (read by Claude Code; only if Claude Code is installed)
# Symlinks mean `git pull` in this repo updates the installed skills. An existing
# real folder with the same name is renamed to <name>.backup-<date>, never deleted.
# Safe to run again: links and copies this script made are replaced, not backed up.
#
# Usage: ./install.sh            link (recommended)
#        ./install.sh --copy     copy instead of linking (re-run after updates)
#        ./install.sh --uninstall
set -eu

mode=link
case "${1:-}" in
  --copy) mode=copy ;;
  --uninstall) mode=uninstall ;;
  "") ;;
  *) echo "Unknown option: $1" >&2; exit 2 ;;
esac

here=$(cd "$(dirname "$0")" && pwd)
targets="$HOME/.agents/skills"
if [ -d "$HOME/.claude" ]; then targets="$targets $HOME/.claude/skills"
else echo "Claude Code not found (no ~/.claude); installing for Copilot only."; fi
stamp=$(date +%Y%m%d-%H%M%S)

for skill in "$here"/skills/*/; do
  name=$(basename "$skill")
  for dir in $targets; do
    dest="$dir/$name"
    if [ "$mode" = uninstall ]; then
      if [ -L "$dest" ]; then rm "$dest"; echo "Removed link $dest"
      elif [ -f "$dest/.installed-copy" ]; then rm -rf "$dest"; echo "Removed copy $dest"; fi
      continue
    fi
    if [ "$mode" = link ] && [ -L "$dest" ] && [ "$(cd -P "$dest" 2>/dev/null && pwd)" = "$(cd -P "$skill" && pwd)" ]; then
      echo "Already linked $dest"; continue
    fi
    mkdir -p "$dir"
    if [ -L "$dest" ]; then rm "$dest"
    elif [ -f "$dest/.installed-copy" ]; then rm -rf "$dest"
    elif [ -e "$dest" ]; then
      backup="$dest.backup-$stamp"; n=1
      while [ -e "$backup" ]; do n=$((n + 1)); backup="$dest.backup-$stamp-$n"; done
      mv "$dest" "$backup"; echo "Existing folder kept as $backup"
    fi
    if [ "$mode" = copy ]; then
      cp -R "${skill%/}" "$dest" && touch "$dest/.installed-copy"; echo "Copied $name -> $dest"
    else
      ln -s "${skill%/}" "$dest"
      if [ ! -L "$dest" ]; then
        # Git Bash on Windows silently copies instead of linking.
        rm -rf "$dest"
        echo "Couldn't create a symlink at $dest. On Windows, use install.ps1 (or run this with --copy)." >&2
        exit 1
      fi
      echo "Linked $dest -> ${skill%/}"
    fi
  done
done
[ "$mode" = uninstall ] || printf '\nDone. Restart VS Code / Claude Code, then type / in chat to see the skills.\n'
