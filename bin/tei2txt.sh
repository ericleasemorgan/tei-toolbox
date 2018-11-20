#!/usr/bin/env bash


# configure
TEI2TXT='./etc/tei2txt.xsl'

ID=$1
ID=$( basename $ID .xml)

TEI="./tei/$ID.xml"
TXT="./txt/$ID.txt"

xsltproc $TEI2TXT $TEI > $TXT
