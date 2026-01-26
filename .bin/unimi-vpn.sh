#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: unimi-vpn.sh [-c config] [-a auth_file] [-h]

Connect to the Unimi VPN using the bundled OpenVPN profile.

Options:
  -c config     Path to the .ovpn config (default: repo_root/unimi.ovpn or $UNIMI_OVPN_CONFIG)
  -a auth_file  Path to an existing auth-user-pass file (optional; if omitted you'll be prompted each run)
  -h            Show this help message

The script invokes openvpn via sudo and prompts for credentials at runtime when
no auth file is provided.
EOF
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"

config="${UNIMI_OVPN_CONFIG:-"${repo_root}/unimi.ovpn"}"
auth_file="${UNIMI_OVPN_AUTH:-}"

while getopts "c:a:h" opt; do
  case "$opt" in
    c) config="$OPTARG" ;;
    a) auth_file="$OPTARG" ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: required command '$1' not found in PATH." >&2
    exit 1
  fi
}



require_cmd openvpn
require_cmd sudo

if [[ ! -f "$config" ]]; then
  echo "Error: config file not found at $config" >&2
  exit 1
fi

auth_path="$auth_file"

if [[ -n "$auth_path" ]]; then
  if [[ ! -f "$auth_path" ]]; then
    echo "Error: auth file not found at $auth_path" >&2
    exit 1
  fi
else
  auth_path="$(mktemp -t unimi-vpn-auth.XXXXXX)"
  trap 'rm -f "$auth_path"' EXIT
  read -r -p "Username: " user
  read -r -s -p "Password: " pass
  echo
  {
    echo "$user"
    echo "$pass"
  } >"$auth_path"
  chmod 600 "$auth_path"
fi

echo "Connecting with config: $config"
echo "Using auth file: $auth_path"
echo "You may be prompted for your sudo password to start OpenVPN."
sudo openvpn --config "$config" --auth-user-pass "$auth_path"
