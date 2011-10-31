#!/bin/sh
#    Z97-byobu.sh - allow any user to opt into auto-launching byobu
#    Copyright (C) 2011 Canonical Ltd.
#
#    Authors: Dustin Kirkland <kirkland@ubuntu.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, version 3 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Allow any user to opt into auto-launching byobu by setting LC_BYOBU=1
# Apologies for borrowing the LC_BYOBU namespace, but:
#  a) it's reasonable to assume that no one else is using LC_BYOBU
#  b) LC_* is sent and receieved by most /etc/ssh/ssh*_config
if [ "$LC_BYOBU" = "1" ] && [ -r "/usr/bin/byobu-launch" ]; then
	. /usr/bin/byobu-launch
fi
true

# vi: syntax=sh ts=4 noexpandtab
