#!/bin/sh
set -eu

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
NVIM_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

usage() {
  cat <<'EOF'
Usage: sh scripts/neovim.sh <install|uninstall|reinstall|sync>

Commands:
  install     Apply this repo's chezmoi-managed NvChad config and sync plugins.
  uninstall   Remove Neovim config, data, state, and cache directories.
  reinstall   Run uninstall, then install.
  sync        Run lazy.nvim plugin sync for the current Neovim config.

This script removes Neovim user config/runtime data only. It does not uninstall
the Homebrew neovim binary.
EOF
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

need_command() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

cleanup_clean_git() {
  [ -z "${NVCHAD_GIT_WRAPPER_DIR:-}" ] || rm -rf "$NVCHAD_GIT_WRAPPER_DIR"
  [ -z "${NVCHAD_GIT_HOME:-}" ] || rm -rf "$NVCHAD_GIT_HOME"
}

prepare_clean_git() {
  [ -z "${NVCHAD_GIT_WRAPPER_DIR:-}" ] || return 0

  need_command git
  NVCHAD_REAL_GIT="$(command -v git)"
  tmp_base="${TMPDIR:-/tmp}"
  NVCHAD_GIT_HOME="$(mktemp -d "$tmp_base/nvchad-git-home.XXXXXX")"
  NVCHAD_GIT_WRAPPER_DIR="$(mktemp -d "$tmp_base/nvchad-git-bin.XXXXXX")"
  export NVCHAD_REAL_GIT NVCHAD_GIT_HOME

  cat > "$NVCHAD_GIT_WRAPPER_DIR/git" <<'EOF'
#!/bin/sh
: "${NVCHAD_REAL_GIT:?}"
: "${NVCHAD_GIT_HOME:?}"
HOME="$NVCHAD_GIT_HOME" GIT_CONFIG_NOSYSTEM=1 exec "$NVCHAD_REAL_GIT" "$@"
EOF
  chmod +x "$NVCHAD_GIT_WRAPPER_DIR/git"
  export PATH="$NVCHAD_GIT_WRAPPER_DIR:$PATH"
}

trap cleanup_clean_git EXIT

uninstall_nvim() {
  [ -n "$NVIM_CONFIG_DIR" ] || die "NVIM_CONFIG_DIR is empty"
  [ -n "$NVIM_DATA_DIR" ] || die "NVIM_DATA_DIR is empty"
  [ -n "$NVIM_STATE_DIR" ] || die "NVIM_STATE_DIR is empty"
  [ -n "$NVIM_CACHE_DIR" ] || die "NVIM_CACHE_DIR is empty"

  rm -rf "$NVIM_CONFIG_DIR" "$NVIM_DATA_DIR" "$NVIM_STATE_DIR" "$NVIM_CACHE_DIR"
  printf '%s\n' "Removed Neovim config, data, state, and cache directories."
}

sync_nvim() {
  need_command nvim
  prepare_clean_git
  nvim --headless "+Lazy! sync" +qa || die "lazy.nvim sync did not finish."
}

install_nvim() {
  need_command chezmoi

  chezmoi -S "$REPO_DIR" apply -v "$NVIM_CONFIG_DIR"
  sync_nvim
  printf '%s\n' "Neovim config installed from $REPO_DIR."
}

case "${1:-}" in
  install)
    install_nvim
    ;;
  uninstall)
    uninstall_nvim
    ;;
  reinstall)
    uninstall_nvim
    install_nvim
    ;;
  sync)
    sync_nvim
    ;;
  -h|--help|help|"")
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
