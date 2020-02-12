#!/usr/bin/env bash


# configure
TRASH="./tmp"

ID=$1
ID=$( basename $ID .xml)


TEI="./xml/$ID.xml"
mv $TEI $TRASH
xmllint --format "$TRASH/$ID.xml" > $TEI

