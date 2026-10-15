#!/usr/bin/env sh
# Saves an HTML page as a new version under ~/artifacts/<slug>/ and opens it (macOS / Linux).
#
# Copies the page to ~/artifacts/<slug>/index.html. The previous index.html is kept
# as index.<yyyymmdd-HHMMSS>.html, so every save is a version. If the page hasn't
# changed, no version is made. An assets/ folder next to the page is copied too
# (files are added or replaced, never deleted, so older versions keep their images).
#
# Usage: save.sh --file <page.html> [--name <slug>] [--no-open]
#   --name     the slug, which names the folder. Defaults to the file name, or to
#              the parent folder's name when the file is called index.html.
#   --no-open  don't open the page in the browser (remote or headless sessions).
set -eu

file= name= open=1
while [ $# -gt 0 ]; do
  case "$1" in
    --file) file=${2:?--file needs a path}; shift 2 ;;
    --name) name=${2:?--name needs a value}; shift 2 ;;
    --no-open) open=0; shift ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; exit 2 ;;
    *) file=$1; shift ;;
  esac
done
[ -n "$file" ] || { echo "Usage: save.sh --file <page.html> [--name <slug>] [--no-open]" >&2; exit 2; }
[ -f "$file" ] || { echo "No such file: $file" >&2; exit 1; }

src_dir=$(cd "$(dirname "$file")" && pwd)
src="$src_dir/$(basename "$file")"

if [ -z "$name" ]; then
  name=$(basename "$src" .html)
  [ "$name" = index ] && name=$(basename "$src_dir")
fi
slug=$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]\{1,\}/-/g; s/^-//; s/-$//')
[ -n "$slug" ] || { echo "Can't make a folder name from '$name'. Pass --name with letters or digits." >&2; exit 1; }

dir="$HOME/artifacts/$slug"
dest="$dir/index.html"
if [ "$src" -ef "$dest" ]; then
  echo "That's the saved page itself. Write the new version somewhere else, then save it." >&2; exit 1
fi
mkdir -p "$dir"

if [ -f "$dest" ] && cmp -s "$src" "$dest"; then
  echo "Unchanged; no new version made."
else
  if [ -f "$dest" ]; then
    stamp=$(date +%Y%m%d-%H%M%S)
    old="$dir/index.$stamp.html"; n=1
    while [ -e "$old" ]; do n=$((n + 1)); old="$dir/index.$stamp-$n.html"; done
    mv "$dest" "$old"
    echo "Previous version kept as $old"
  fi
  cp "$src" "$dest"
fi

if [ -d "$src_dir/assets" ] && [ ! "$src_dir" -ef "$dir" ]; then
  mkdir -p "$dir/assets"
  cp -R "$src_dir/assets/." "$dir/assets/"
  echo "Copied assets folder."
fi

version=$(( $(find "$dir" -maxdepth 1 -name 'index.*.html' | wc -l) + 1 ))
if command -v cygpath >/dev/null 2>&1; then url="file:///$(cygpath -m "$dest")"; else url="file://$dest"; fi
echo "Saved $dest (version $version)"
echo "Open: $url   (add ?theme=dark or ?theme=light to check a theme)"

if [ "$open" = 1 ]; then
  if [ "$(uname)" = Darwin ]; then open "$dest"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$dest" >/dev/null 2>&1 &
  elif command -v cygpath >/dev/null 2>&1; then explorer "$(cygpath -w "$dest")" || true
  else echo "Couldn't find a way to open a browser; open the path above."
  fi
fi
