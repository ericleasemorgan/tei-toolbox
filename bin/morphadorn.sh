#!/usr/bin/env bash


# configure
MORPHADORN='./bin/morphadorn.py'

ID=$1
ID=$( basename $ID .xml)

XML="./xml/$ID.xml"
TEI="./tei/$ID.xml"

$MORPHADORN $XML > $TEI
