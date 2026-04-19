#!/usr/bin/env bash
set -euo pipefail

# Simple dotfiles linker with backups.
# Usage:
#   ./setup.sh              # Link all managed dotfiles into $HOME
#   DRY_RUN=1 ./setup.sh   # Show what would happen without changing anything
#   RELINK=1 ./setup.sh    # Remove and re-create all existing correct symlinks

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_ROOT="${DOTFILES_DIR}/.backup"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${TIMESTAMP}"
DRY_RUN="${DRY_RUN:-0}"
RELINK="${RELINK:-0}"

# List of items to link, expressed as paths relative to the repo root.
ITEMS=(
  ".bin"
  ".zshrc"
  ".gitconfig"
  ".gitignore_global"
  ".config/nvim"
  ".config/ghostty"
  ".config/zed"
  ".git_template"
  "unimi.ovpn"
)

log() {
  printf "[setup] %s\n" "$*"
}

ensure_parent_dir() {
  local path="$1"
  local parent
  parent="$(dirname "$path")"
  if [[ "$DRY_RUN" == "1" ]]; then
    log "DRY RUN: mkdir -p \"$parent\""
  else
    mkdir -p "$parent"
  fi
}

backup_target() {
  local target="$1"
  local rel="$2"

  ensure_parent_dir "$BACKUP_DIR/$rel"

  if [[ "$DRY_RUN" == "1" ]]; then
    log "DRY RUN: mv \"$target\" \"$BACKUP_DIR/$rel\""
  else
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/$rel"
    log "Backed up \"$rel\" to \"$BACKUP_DIR/$rel\""
  fi
}

link_item() {
  local rel="$1"
  local source="${2:-$DOTFILES_DIR/$rel}"
  local target="${3:-$HOME/$rel}"
  local backup_rel="${4:-$rel}"

  if [[ ! -e "$source" ]]; then
    log "SKIP: source \"$rel\" does not exist"
    return
  fi

  ensure_parent_dir "$target"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      if [[ "$RELINK" == "1" ]]; then
        log "Relinking \"$rel\""
        if [[ "$DRY_RUN" == "1" ]]; then
          log "DRY RUN: rm \"$target\""
        else
          rm "$target"
        fi
      else
        log "OK: \"$rel\" already linked"
        return
      fi
    else
      log "Updating symlink for \"$rel\""
      backup_target "$target" "$backup_rel"
    fi
  elif [[ -e "$target" ]]; then
    log "Backing up existing \"$rel\""
    backup_target "$target" "$backup_rel"
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    log "DRY RUN: ln -s \"$source\" \"$target\""
  else
    ln -s "$source" "$target"
    log "Linked \"$rel\" -> \"$source\""
  fi
}

main() {
  log "Dotfiles directory: $DOTFILES_DIR"
  log "Backup directory:   $BACKUP_DIR"
  if [[ "$DRY_RUN" == "1" ]]; then
    log "Running in DRY RUN mode; no changes will be made."
  fi
  if [[ "$RELINK" == "1" ]]; then
    log "Running in RELINK mode; existing symlinks will be re-created."
  fi

  for item in "${ITEMS[@]}"; do
    link_item "$item"
  done

  # VS Code settings/keymap symlinking for macOS and Linux
  OS_TYPE="$(uname)"
  if [[ "$OS_TYPE" == "Darwin" ]]; then
    VSCODE_TARGET_DIR="$HOME/Library/Application Support/Code/User"
    VSCODE_BACKUP_PREFIX="Library/Application Support/Code/User"
  else
    VSCODE_TARGET_DIR="$HOME/.config/Code/User"
    VSCODE_BACKUP_PREFIX=".config/Code/User"
  fi
  for f in "settings.json" "keybindings.json"; do
    link_item \
      ".config/Code/$f" \
      "$DOTFILES_DIR/.config/Code/$f" \
      "$VSCODE_TARGET_DIR/$f" \
      "$VSCODE_BACKUP_PREFIX/$f"
  done

  log "Done."
  if [[ "$DRY_RUN" == "0" && -d "$BACKUP_DIR" ]]; then
    log "Backups stored in: $BACKUP_DIR"
  fi
}

main "$@"
