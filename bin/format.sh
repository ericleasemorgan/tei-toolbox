#!/usr/bin/env bash


# configure
TRASH="./trash"

ID=$1
ID=$( basename $ID .xml)


TEI="./tei/$ID.xml"
mv $TEI $TRASH
xmllint --format "$TRASH/$ID.xml" > $TEI

