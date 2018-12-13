#!/usr/bin/env bash

# txt2xml.sh - given a file, output a rudimentary TEI file; a front-end to txt2xml.pl


# configure
TXT2XML='./bin/txt2xml.pl'
DIRECTORY='./xml'

# sanity check
if [[ -z "$1" ]]; then
	echo "Usage: $0 <file>" >&2
	exit
fi

# get input
FILE=$1

# initialize
BASENAME=$( basename $FILE )
BASENAME=${BASENAME%.*}
OUTPUT="$DIRECTORY/$BASENAME.xml"

# do the work and done
$TXT2XML $FILE $BASENAME > $OUTPUT
exit
