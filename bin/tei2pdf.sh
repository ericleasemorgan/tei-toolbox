#!/usr/bin/env bash


# configure
CARRELS='./carrels'
FOP='/Applications/fop/fop'
HOME=$( pwd )
TEI2FO='./etc/tei2fo.xsl'

# sanity check
if [[ -z "$1" || -z "$2" ]]; then
	echo "Usage: $0 <TEI file> <name>" >&2
	exit
fi

# get input
FILE=$1
NAME=$2

# initialize
KEY=$( basename $FILE .xml )
CARREL="$CARRELS/$NAME"
TEI="$CARREL/tei/$KEY.xml"
FO="$HOME/$CARREL/fo/$KEY.fo"
PDF="$HOME/$CARREL/pdf/$KEY.pdf"

# create fo, and then create pdf
xsltproc $TEI2FO $TEI > $FO
cd $FOP
./fop $FO $PDF