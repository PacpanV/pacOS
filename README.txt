pacpantop

Author: Pacpan

AI assistant helper:

This script was developed with help from OpenCode using the gpt-5.5 model.

What it does:

pacpantop is a lightweight TTY LAN monitor.

It scans a local /24 network, reads the local neighbor table, tracks visible devices, and shows their status in a terminal interface.

It can help notice when devices appear, disappear, or need authorization.

It can also trigger a beep alert when device status changes, so it can work as a simple warning monitor on a TTY machine.

It does not need internet access. It only needs a local network and common Linux networking tools such as ping and ip.

Private data:
pacpantop creates its own local data files in the user's home directory on first run:

- ~/lan-known-devices.txt
- ~/lan-authorized-macs.txt
- ~/lan-blocked-devices.txt
- ~/lan-ssh-users.txt
- ~/lan-online-since.txt

These files may contain private local network information and should not be published.

Install:

Run this from the pacpantop directory:

sh install.sh

The installer asks for the user's password through sudo, makes the script executable, and installs pacpantop as:

/usr/local/bin/pacpantop

Run:

Default subnet:

pacpantop

Custom /24 subnet:

pacpantop 192.168.1

License:

GNU General Public License version 3. See LICENSE.
