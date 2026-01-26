# dotfiles

This repository contains my personal dotfiles and a helper script to link them into place with optional dry-run support.

## Setup

Run the setup script from the repo root:

- `./setup.sh` — link all managed items into `$HOME`
- `DRY_RUN=1 ./setup.sh` — show what would happen without making changes (prints planned backups and symlinks)

The script backs up pre-existing files into `.backup/<timestamp>` before replacing them with symlinks. Managed items are listed inside `setup.sh` in the `ITEMS` array.

## Contact

If you have any questions, suggestions, or feedback, do not hesitate to [contact me](https://federicobruzzone.github.io/).
