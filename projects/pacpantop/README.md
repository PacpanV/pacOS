# pacpantop

`pacpantop` is a lightweight TTY LAN monitor for Linux.

It scans a local `/24` network, reads the local neighbor table, tracks visible devices, and displays their status in a terminal interface. It can help notice when devices appear, disappear, or need authorization.

It can also trigger a beep alert when device status changes, making it useful as a simple always-on warning monitor on a TTY machine.

## Author

Pacpan

GitHub: <https://github.com/PacpanV>

## AI Assistant Help

This script was developed with help from OpenCode using the `gpt-5.5` model.

## What It Does

- Scans a local `/24` subnet using `ping`.
- Reads visible devices from `ip neigh`.
- Tracks device status as online, offline, pending, or blocked.
- Lets the user name and authorize devices interactively.
- Stores local device state in text files under the user's home directory.
- Can beep when device status changes.
- Can optionally use SSH to fetch extra info from reachable Linux devices.

It does not need internet access. It only needs a local network and common Linux networking tools such as `ping` and `ip`.

## Install

Run this from the `pacpantop` directory:

```sh
sh install.sh
```

The installer asks for the user's password through `sudo`, makes the script executable, and installs:

```text
/usr/local/bin/pacpantop
```

## Run

Default subnet:

```sh
pacpantop
```

Custom `/24` subnet:

```sh
pacpantop 192.168.1
```

## Private Data

`pacpantop` creates local data files in the user's home directory on first run:

```text
~/lan-known-devices.txt
~/lan-authorized-macs.txt
~/lan-blocked-devices.txt
~/lan-ssh-users.txt
~/lan-online-since.txt
```

These files may contain private local network information and should not be published.

They are ignored by `.gitignore`.

## Requirements

Required commands:

- `sh`
- `ping`
- `ip`
- `awk`
- `sed`
- `sort`
- common core utilities

Optional commands:

- `ssh`, for extra remote device info
- `speaker-test`, for audible alerts when available
- `setfont`, for better TTY font when available

## License

GNU General Public License version 3. See `LICENSE`.
