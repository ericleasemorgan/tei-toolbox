#!/usr/bin/env bash


# configure
TEI2FO='./etc/tei2fo.xsl'
FOP='/Applications/fop/fop'
HOME=$( pwd )

ID=$1
ID=$( basename $ID .xml)

TEI="./tei/$ID.xml"
FO="$HOME/fo/$ID.fo"
PDF="$HOME/pdf/$ID.pdf"

xsltproc $TEI2FO $TEI > $FO

cd $FOP
./fop $FO $PDF