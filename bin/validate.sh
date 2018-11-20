#!/usr/bin/env bash


# configure
DTD="./etc/tei.dtd"

ID=$1


TEI="./tei/$ID.xml"
xmllint --noout --dtdvalid $DTD $TEI
