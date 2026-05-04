pacpantop

Author: Pacpan

AI assistant helper:

This script was developed with help from OpenCode using the gpt-5.5 model.

What it does:

pacpantop is a lightweight TTY LAN monitor.

It scans a local /24 network, reads the local neighbor table, tracks visible devices, and shows their status in a terminal interface.

It can help notice when devices appear, disappear, or need authorization.

It can also trigger a beep alert when device status changes, so it can work as a simple warning monitor on a TTY machine.

After installation, it does not need internet access. It only needs a local network and common Linux networking tools such as ping and ip.

Private data:
pacpantop creates its own local data files in the user's home directory on first run:

- ~/lan-known-devices.txt
- ~/lan-authorized-macs.txt
- ~/lan-blocked-devices.txt
- ~/lan-ssh-users.txt
- ~/lan-online-since.txt

These files may contain private local network information and should not be published.

Install:

Direct install needs sudo and either curl or wget. The git method needs git.

Install directly from GitHub with curl:

curl -fsSL https://raw.githubusercontent.com/PacpanV/pacOS/main/projects/pacpantop/install.sh | sh

Or with wget:

wget -qO- https://raw.githubusercontent.com/PacpanV/pacOS/main/projects/pacpantop/install.sh | sh

Or clone the repo and run the installer locally:

git clone https://github.com/PacpanV/pacOS.git
cd pacOS/projects/pacpantop
sh install.sh

The installer asks for the user's password through sudo, downloads pacpantop when needed, makes the script executable, and installs pacpantop as:

/usr/local/bin/pacpantop

If you do not want to pipe a script into sh, download it first and inspect it:

curl -fsSLO https://raw.githubusercontent.com/PacpanV/pacOS/main/projects/pacpantop/install.sh
less install.sh
sh install.sh

Run:

Auto-detect the active IPv4 /24 subnet:

pacpantop

Custom /24 subnet:

pacpantop 10.0.0

Pass only the first three octets of the subnet. For example, pacpantop 10.0.0 scans 10.0.0.1 through 10.0.0.254.

Demo:

Try the visual browser demo:

https://pacpanv.github.io/pacOS/projects/pacpantop/demo/

The demo uses fake LAN data. Browsers cannot scan a user's LAN directly; install pacpantop to monitor a real local network.


License:

GNU General Public License version 3. See LICENSE.
