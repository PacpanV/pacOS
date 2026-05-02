#!/bin/sh

SUBNET="${1:-192.168.0}"
KNOWN_FILE="${KNOWN_FILE:-$HOME/lan-known-devices.txt}"
AUTH_FILE="${AUTH_FILE:-$HOME/lan-authorized-macs.txt}"
BLOCK_FILE="${BLOCK_FILE:-$HOME/lan-blocked-devices.txt}"

init_data_files() {
    for file in "$KNOWN_FILE" "$AUTH_FILE" "$BLOCK_FILE"; do
        [ -f "$file" ] || : > "$file"
    done
}

init_data_files

lookup_name() {
    ip="$1"

    if [ -f "$KNOWN_FILE" ]; then
        awk -v ip="$ip" '
            $1 == ip {
                $1=""
                sub(/^ /, "")
                print
                exit
            }
        ' "$KNOWN_FILE"
    fi
}

is_authorized_mac() {
    [ -f "$AUTH_FILE" ] || return 1
    awk -v mac="$1" 'tolower($1) == tolower(mac) {found=1} END {exit found ? 0 : 1}' "$AUTH_FILE"
}

is_blocked_mac() {
    [ -f "$BLOCK_FILE" ] || return 1
    awk -v mac="$1" 'tolower($2) == tolower(mac) {found=1} END {exit found ? 0 : 1}' "$BLOCK_FILE"
}

tmp="/tmp/lan-devices.$$"
: > "$tmp"
trap 'rm -f "$tmp"' EXIT INT TERM

i=1
while [ "$i" -le 254 ]; do
    ping -c 1 -W 1 "$SUBNET.$i" >/dev/null 2>&1 &
    i=$((i + 1))
done
wait

ip neigh show | while read -r line; do
    ip=$(printf '%s\n' "$line" | awk '{print $1}')
    mac=$(printf '%s\n' "$line" | awk '{for (i=1; i<=NF; i++) if ($i == "lladdr") print $(i+1)}')
    state=$(printf '%s\n' "$line" | awk '{print $NF}')

    case "$ip" in
        "$SUBNET".*) ;;
        *) continue ;;
    esac

    [ -z "$mac" ] && continue
    [ "$state" = "FAILED" ] && continue
    [ "$state" = "INCOMPLETE" ] && continue

    name=$(lookup_name "$ip")
    [ -z "$name" ] && name="-"

    status="pending"
    is_authorized_mac "$mac" && status="online"
    is_blocked_mac "$mac" && status="blocked"

    printf '%s|%s|%s|%s\n' "$ip" "$mac" "$name" "$status" >> "$tmp"
done

if [ -f "$KNOWN_FILE" ]; then
    while read -r known_ip known_name; do
        [ -z "$known_ip" ] && continue
        case "$known_ip" in \#*) continue ;; esac

        if ! awk -F '|' -v ip="$known_ip" '$1 == ip {found=1} END {exit found ? 0 : 1}' "$tmp"; then
            [ -z "$known_name" ] && known_name="-"
            printf '%s|%s|%s|offline\n' "$known_ip" "-" "$known_name" >> "$tmp"
        fi
    done < "$KNOWN_FILE"
fi

printf '%-15s %-19s %-22s %-8s\n' "IP" "MAC" "NAME" "STATUS"
printf '%-15s %-19s %-22s %-8s\n' "--" "---" "----" "------"
sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n "$tmp" | awk -F '|' '!seen[$1]++' | while IFS='|' read -r ip mac name status; do
    printf '%-15.15s %-19.19s %-22.22s %-8.8s\n' "$ip" "$mac" "$name" "$status"
done
