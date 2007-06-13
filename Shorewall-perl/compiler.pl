#! /usr/bin/perl -w
#
#     The Shoreline Firewall4 (Shorewall-perl) Packet Filtering Firewall Compiler - V4.0
#
#     This program is under GPL [http://www.gnu.org/copyleft/gpl.htm]
#
#     (c) 2007 - Tom Eastep (teastep@shorewall.net)
#
#	Complete documentation is available at http://shorewall.net
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of Version 2 of the GNU General Public License
#	as published by the Free Software Foundation.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program; if not, write to the Free Software
#	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA
#
# See usage() function below for command line syntax.
#
use strict;
use lib '/usr/share/shorewall-perl';
use Shorewall::Compiler;
use Getopt::Long;

sub usage() {
    print STDERR "usage: compiler.pl [ --export ] [ --directory=<directory> ] [ --verbose={0-2} ] [ --timestamp ] [ <filename> ]\n";
    exit 1;
}

#
#                                     E x e c u t i o n   S t a r t s   H e r e
#
my $export        = $ENV{EXPORT}        || 0;
my $shorewall_dir = $ENV{SHOREWALL_DIR} || '';
my $verbose       = $ENV{VERBOSE}       || 0;
my $timestamp     = $ENV{TIMESTAMP}     || '';

Getopt::Long::Configure ('bundling');

my $result = GetOptions('export'      => \$export,
			'e'           => \$export,
			'directory=s' => \$shorewall_dir,
			'd=s'         => \$shorewall_dir,
			'verbose=i'   => \$verbose,
			'v=i'         => \$verbose,
			'timestamp'   => \$timestamp,
			't'           => \$timestamp );

usage unless $result && @ARGV < 2;

my $options = 0;

$options |= EXPORT    if $export;
$options |= TIMESTAMP if $timestamp;

compiler $ARGV[0], $shorewall_dir, $verbose, $options;
