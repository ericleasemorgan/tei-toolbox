#!/usr/bin/env bash


# configure
TEI2TXT='./etc/tei2txt.xsl'
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
KEY=$( basename $FILE .xml)
CARREL="$CARRELS/$NAME"
TEI="$CARREL/tei/$KEY.xml"
TXT="$CARREL/txt/$KEY.txt"

# do the work
xsltproc $TEI2TXT $TEI > $TXT
