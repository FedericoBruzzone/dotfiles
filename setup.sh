#!/usr/bin/env bash
set -euo pipefail

# Simple dotfiles linker with backups.
# Usage:
#   ./setup.sh           # Link all managed dotfiles into $HOME
#   DRY_RUN=1 ./setup.sh # Show what would happen without changing anything

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_ROOT="${DOTFILES_DIR}/.backup"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${TIMESTAMP}"
DRY_RUN="${DRY_RUN:-0}"

# List of items to link, expressed as paths relative to the repo root.
ITEMS=(
  ".bin"
  ".zshrc"
  ".gitconfig"
  ".config/nvim"
  ".config/ghostty"
  ".config/zed"
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
  local source="$DOTFILES_DIR/$rel"
  local target="$HOME/$rel"

  if [[ ! -e "$source" ]]; then
    log "SKIP: source \"$rel\" does not exist"
    return
  fi

  ensure_parent_dir "$target"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      log "OK: \"$rel\" already linked"
      return
    else
      log "Updating symlink for \"$rel\""
      backup_target "$target" "$rel"
    fi
  elif [[ -e "$target" ]]; then
    log "Backing up existing \"$rel\""
    backup_target "$target" "$rel"
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

  for item in "${ITEMS[@]}"; do
    link_item "$item"
  done

  log "Done."
  if [[ "$DRY_RUN" == "0" && -d "$BACKUP_DIR" ]]; then
    log "Backups stored in: $BACKUP_DIR"
  fi
}

main "$@"
