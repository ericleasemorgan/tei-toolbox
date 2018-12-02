#!/usr/bin/env bash


# configure
TEI2HTML='./etc/tei2html.xsl'
CARRELS='./carrels'

# sanity check
if [[ -z "$1" || -z "$2" ]]; then
	echo "Usage: $0 <file> <name>" >&2
	exit
fi

# get input
FILE=$1
NAME=$2

# initialize
KEY=$( basename $FILE .xml )
CARREL="$CARRELS/$NAME"
TEI="$CARREL/tei/$KEY.xml"
HTML="$CARREL/html/$KEY.html"

# do the work
xsltproc $TEI2HTML $TEI > $HTML