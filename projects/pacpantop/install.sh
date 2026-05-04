#!/usr/bin/env sh
set -eu

raw_base_url="${PACPANTOP_BASE_URL:-https://raw.githubusercontent.com/PacpanV/pacOS/main/projects/pacpantop}"
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd 2>/dev/null || printf '.')
local_script="$script_dir/pacpantop"
tmp_dir=""

cleanup() {
    [ -z "$tmp_dir" ] || rm -rf "$tmp_dir"
}
trap cleanup EXIT HUP INT TERM

fetch_file() {
    url="$1"
    out="$2"

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$out"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$out" "$url"
    else
        printf 'Error: curl or wget is required for remote installation.\n' >&2
        exit 1
    fi
}

printf 'pacpantop installer\n'
printf 'This will ask for your password through sudo.\n\n'

if ! command -v sudo >/dev/null 2>&1; then
    printf 'Error: sudo is required for installation to /usr/local/bin.\n' >&2
    exit 1
fi

sudo -v

if [ -f "$local_script" ]; then
    source_script="$local_script"
else
    tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/pacpantop-install.XXXXXX")
    source_script="$tmp_dir/pacpantop"
    printf 'Downloading pacpantop from GitHub...\n'
    fetch_file "$raw_base_url/pacpantop" "$source_script"
fi

chmod +x "$source_script"

sudo install -m 0755 "$source_script" /usr/local/bin/pacpantop

printf '\nInstalled pacpantop as:\n'
printf '/usr/local/bin/pacpantop\n\n'
printf 'Run it with:\n'
printf 'pacpantop\n\n'
printf 'Or scan another /24 subnet by passing the first three octets:\n'
printf 'pacpantop 10.0.0\n'
