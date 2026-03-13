# dotfiles

This repository contains my personal dotfiles and a helper script to link them into place with optional dry-run and re-link support.

## Setup

Run the setup script from the repo root:

- `./setup.sh` — link all managed items into `$HOME`
- `DRY_RUN=1 ./setup.sh` — show what would happen without making changes (prints planned backups and symlinks)
- `RELINK=1 ./setup.sh` — remove and re-create all existing correct symlinks
- `DRY_RUN=1 RELINK=1 ./setup.sh` — preview a full re-link without making changes

The flags can be combined freely.

The script backs up pre-existing files into `.backup/<timestamp>` before replacing them with symlinks. Managed items are listed inside `setup.sh` in the `ITEMS` array.

## VS Code

VS Code settings and keybindings are handled separately from the main `ITEMS` array because the target path differs by OS:

| OS    | Target directory                                   |
|-------|----------------------------------------------------|
| macOS | `~/Library/Application Support/Code/User/`         |
| Linux | `~/.config/Code/User/`                             |

The source files live in `.config/Code/` inside this repo and are symlinked automatically by `setup.sh` alongside the rest of the dotfiles.

## Contact

If you have any questions, suggestions, or feedback, do not hesitate to [contact me](https://federicobruzzone.github.io/).