#!/bin/sh
#
# Script to back uninstall Shoreline Firewall
#
#     This program is under GPL [http://www.gnu.org/copyleft/gpl.htm]
#
#     (c) 2000,2001,2002,2003 - Tom Eastep (teastep@shorewall.net)
#
#       Shorewall documentation is available at http://shorewall.sourceforge.net
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of Version 2 of the GNU General Public License
#       as published by the Free Software Foundation.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA
#
#    Usage:
#
#       You may only use this script to uninstall the version
#       shown below. Simply run this script to remove Seattle Firewall

VERSION=1.4.8

usage() # $1 = exit status
{
    ME=`basename $0`
    echo "usage: $ME"
    exit $1
}

qt()
{
    "$@" >/dev/null 2>&1
}

restore_file() # $1 = file to restore
{
    if [ -f ${1}-shorewall.bkout ]; then
	if (mv -f ${1}-shorewall.bkout $1); then
	    echo
	    echo "$1 restored"
        else
	    exit 1
        fi
    fi
}

remove_file() # $1 = file to restore
{
    if [ -f $1 -o -L $1 ] ; then
	rm -f $1
	echo "$1 Removed"
    fi
}

if [ -f /usr/lib/shorewall/version ]; then
    INSTALLED_VERSION="`cat /usr/lib/shorewall/version`"
    if [ "$INSTALLED_VERSION" != "$VERSION" ]; then
	echo "WARNING: Shorewall Version $INSTALLED_VERSION is installed"
	echo "         and this is the $VERSION uninstaller."
	VERSION="$INSTALLED_VERSION"
    fi
else
    echo "WARNING: Shorewall Version $VERSION is not installed"
    VERSION=""
fi

echo "Uninstalling Shorewall $VERSION"

if qt iptables -L shorewall -n; then
   /sbin/shorewall clear
fi

if [ -L /usr/lib/shorewall/firewall ]; then
    FIREWALL=`ls -l /usr/lib/shorewall/firewall | sed 's/^.*> //'`
elif [ -L /var/lib/shorewall/firewall ]; then
    FIREWALL=`ls -l /var/lib/shorewall/firewall | sed 's/^.*> //'`
elif [ -L /usr/lib/shorewall/init ]; then
    FIREWALL=`ls -l /usr/lib/shorewall/init | sed 's/^.*> //'`
else
    FIREWALL=
fi

if [ -n "$FIREWALL" ]; then
    if [ -x /sbin/insserv -o -x /usr/sbin/insserv ]; then
        insserv -r $FIREWALL
    elif [ -x /sbin/chkconfig -o -x /usr/sbin/chkconfig ]; then
	chkconfig --del `basename $FIREWALL`
    fi

    remove_file $FIREWALL
    rm -f ${FIREWALL}-*.bkout
fi

rm -f /sbin/shorewall
rm -f /sbin/shorewall-*.bkout

if [ -n "$VERSION" ]; then
    restore_file /etc/rc.d/rc.local
fi

rm -rf /etc/shorewall
rm -rf /usr/lib/shorewall
rm -rf /var/lib/shorewall
rm -rf /usr/share/shorewall

echo "Shorewall Uninstalled"


