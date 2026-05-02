#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

printf 'pacpantop installer\n'
printf 'This will ask for your password through sudo.\n\n'

if ! command -v sudo >/dev/null 2>&1; then
    printf 'Error: sudo is required for installation to /usr/local/bin.\n' >&2
    exit 1
fi

sudo -v

chmod +x "$script_dir/pacpantop"
[ -f "$script_dir/lan-devices.sh" ] && chmod +x "$script_dir/lan-devices.sh"

sudo install -m 0755 "$script_dir/pacpantop" /usr/local/bin/pacpantop

printf '\nInstalled pacpantop as:\n'
printf '/usr/local/bin/pacpantop\n\n'
printf 'Run it with:\n'
printf 'pacpantop\n\n'
printf 'Or scan another /24 subnet with:\n'
printf 'pacpantop 192.168.1\n'
