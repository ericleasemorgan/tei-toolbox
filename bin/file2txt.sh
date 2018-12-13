#!/usr/bin/env bash

# file2txt.sh - given a file, output plain text; a front-end to file2txt.py


# configure
FILE2TXT='./file2txt.py'
DIRECTORY='.'

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
OUTPUT="$DIRECTORY/$BASENAME.txt"

# do the work and done
$FILE2TXT $FILE > $OUTPUT
exit
