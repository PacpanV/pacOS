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

After installation, it does not need internet access. It only needs a local network and common Linux networking tools such as `ping` and `ip`.

## Install

Direct install needs `sudo` and either `curl` or `wget`. The `git` method needs `git`.

Install directly from GitHub with `curl`:

```sh
curl -fsSL https://raw.githubusercontent.com/PacpanV/pacOS/main/projects/pacpantop/install.sh | sh
```

Or with `wget`:

```sh
wget -qO- https://raw.githubusercontent.com/PacpanV/pacOS/main/projects/pacpantop/install.sh | sh
```

Or clone the repo and run the installer locally:

```sh
git clone https://github.com/PacpanV/pacOS.git
cd pacOS/projects/pacpantop
sh install.sh
```

The installer asks for the user's password through `sudo`, downloads `pacpantop` when needed, makes the script executable, and installs it as:

```text
/usr/local/bin/pacpantop
```

If you do not want to pipe a script into `sh`, download it first and inspect it:

```sh
curl -fsSLO https://raw.githubusercontent.com/PacpanV/pacOS/main/projects/pacpantop/install.sh
less install.sh
sh install.sh
```

## Run

Auto-detect the active IPv4 `/24` subnet:

```sh
pacpantop
```

Custom `/24` subnet:

```sh
pacpantop 10.0.0
```

Pass only the first three octets of the subnet. For example, `pacpantop 10.0.0` scans `10.0.0.1` through `10.0.0.254`.

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
- `sudo`, for installation to `/usr/local/bin`
- `ping`
- `ip`
- `awk`
- `sed`
- `sort`
- common core utilities

Optional commands:

- `curl`, `wget`, or `git`, for installing from GitHub
- `ssh`, for extra remote device info
- `speaker-test`, for audible alerts when available
- `setfont`, for better TTY font when available

## License

GNU General Public License version 3. See `LICENSE`.
