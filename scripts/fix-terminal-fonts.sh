#!/bin/sh
set -eu

ITERM_FONT="${ITERM_FONT:-HackNFM-Regular 12}"

set_or_add_string() {
  target_plist="$1"
  plist_key="$2"
  plist_value="$3"

  /usr/libexec/PlistBuddy -c "Set $plist_key $plist_value" "$target_plist" >/dev/null 2>&1 ||
    /usr/libexec/PlistBuddy -c "Add $plist_key string $plist_value" "$target_plist"
}

set_or_add_bool() {
  target_plist="$1"
  plist_key="$2"
  plist_value="$3"

  /usr/libexec/PlistBuddy -c "Set $plist_key $plist_value" "$target_plist" >/dev/null 2>&1 ||
    /usr/libexec/PlistBuddy -c "Add $plist_key bool $plist_value" "$target_plist"
}

fix_iterm2_fonts() {
  iterm_plist="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

  if ! defaults read com.googlecode.iterm2 >/dev/null 2>&1 && [ ! -f "$iterm_plist" ]; then
    echo "iTerm2 preferences were not found; skipping iTerm2 font fix."
    return 0
  fi

  tmp_plist="${TMPDIR:-/tmp}/iterm2-fonts.$$.plist"
  if [ -f "$iterm_plist" ]; then
    cp "$iterm_plist" "$tmp_plist"
  else
    defaults export com.googlecode.iterm2 "$tmp_plist"
  fi

  index=0
  while /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':$index:Name" "$tmp_plist" >/dev/null 2>&1; do
    set_or_add_string "$tmp_plist" ":'New Bookmarks':$index:'Normal Font'" "$ITERM_FONT"
    set_or_add_string "$tmp_plist" ":'New Bookmarks':$index:'Non Ascii Font'" "$ITERM_FONT"
    set_or_add_bool "$tmp_plist" ":'New Bookmarks':$index:'Use Non-ASCII Font'" false
    index=$((index + 1))
  done

  plutil -convert binary1 "$tmp_plist" >/dev/null 2>&1 || true

  killall cfprefsd >/dev/null 2>&1 || true
  if ! cp "$tmp_plist" "$iterm_plist" 2>/dev/null; then
    echo "Direct iTerm2 plist write failed; trying defaults import." >&2
    defaults import com.googlecode.iterm2 "$tmp_plist"
  fi
  rm -f "$tmp_plist"

  killall cfprefsd >/dev/null 2>&1 || true
  if [ "$index" -gt 0 ] && [ -f "$iterm_plist" ]; then
    current_font="$(
      /usr/libexec/PlistBuddy -c "Print :'New Bookmarks':0:'Normal Font'" "$iterm_plist" 2>/dev/null || true
    )"
    if [ "$current_font" != "$ITERM_FONT" ]; then
      echo "iTerm2 font update did not persist. Quit iTerm2 completely and run this script again; if it still fails, check write permission for $iterm_plist." >&2
      return 1
    fi
  fi

  echo "Updated $index iTerm2 profile(s) to use $ITERM_FONT."
  echo "Restart iTerm2 or open a new window for the font change to take effect."
}

fix_iterm2_fonts
