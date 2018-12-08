#!/usr/bin/env bash


# configure
MORPHADORN='./bin/morphadorn.py'

# sanity check
if [[ -z "$1"  ]]; then
	echo "Usage: $0 <id>" >&2
	exit
fi

# get input
NAME=$1

ID=$( basename $NAME .xml)

XML="./xml/$ID.xml"
TEI="./tei/$ID.xml"

$MORPHADORN $XML > $TEI
