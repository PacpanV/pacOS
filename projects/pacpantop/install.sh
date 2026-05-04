#!/usr/bin/env sh
set -eu

raw_base_url="${PACPANTOP_BASE_URL:-https://raw.githubusercontent.com/PacpanV/pacOS/main/projects/pacpantop}"
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd 2>/dev/null || printf '.')
local_script="$script_dir/pacpantop"
local_man="$script_dir/pacpantop.1"
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
    source_man="$local_man"
else
    tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/pacpantop-install.XXXXXX")
    source_script="$tmp_dir/pacpantop"
    source_man="$tmp_dir/pacpantop.1"
    printf 'Downloading pacpantop from GitHub...\n'
    fetch_file "$raw_base_url/pacpantop" "$source_script"
    fetch_file "$raw_base_url/pacpantop.1" "$source_man" || source_man=""
fi

chmod +x "$source_script"

sudo install -m 0755 "$source_script" /usr/local/bin/pacpantop

if [ -n "${source_man:-}" ] && [ -f "$source_man" ]; then
    sudo install -Dm 0644 "$source_man" /usr/local/share/man/man1/pacpantop.1
fi

printf '\nInstalled pacpantop as:\n'
printf '/usr/local/bin/pacpantop\n\n'
printf 'Run it with:\n'
printf 'pacpantop\n\n'
printf 'Read the manual with:\n'
printf 'man pacpantop\n\n'
printf 'Or scan another /24 subnet by passing the first three octets:\n'
printf 'pacpantop 10.0.0\n'
