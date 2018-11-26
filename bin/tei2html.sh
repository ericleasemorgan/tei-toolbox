#!/usr/bin/env bash


# configure
TEI2HTML='./etc/tei2html.xsl'

ID=$1
ID=$( basename $ID .xml)

TEI="./xml/$ID.xml"
HTML="./html/$ID.html"

xsltproc $TEI2HTML $TEI > $HTML