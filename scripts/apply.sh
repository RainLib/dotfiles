#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage: sh scripts/apply.sh [target...]

Apply this checkout as the chezmoi source. With no targets, applies the full
repo. With targets, applies only those paths, for example:

  sh scripts/apply.sh ~/.tmux.conf ~/.config/nvim

Set DOTFILES_APPLY_FORCE=1 to pass --force --no-tty to chezmoi for
non-interactive runs.
EOF
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

need_command() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

apply_chezmoi() {
  if [ "${DOTFILES_APPLY_FORCE:-0}" = "1" ]; then
    chezmoi -S "$REPO_DIR" apply --force --no-tty -v "$@"
  else
    chezmoi -S "$REPO_DIR" apply -v "$@"
  fi
}

reload_tmux() {
  command -v tmux >/dev/null 2>&1 || return 0
  [ -f "$HOME/.tmux.conf" ] || return 0
  tmux has-session >/dev/null 2>&1 || return 0

  tmux source-file "$HOME/.tmux.conf"
  printf '%s\n' "Reloaded tmux from $HOME/.tmux.conf."
}

case "${1:-}" in
  -h|--help|help)
    usage
    exit 0
    ;;
esac

need_command chezmoi

if [ "$#" -eq 0 ]; then
  apply_chezmoi
else
  apply_chezmoi "$@"
fi

reload_tmux
