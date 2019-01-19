#!/usr/bin/env bash

# configure
DTD="./etc/tei.dtd"

# sanity check
if [[ -z "$1" || -z "$2" ]]; then
	echo "Usage: $0 <xml|tei> <name>" >&2
	exit
fi

TYPE=$1

ID=$2
ID=$( basename $ID .xml)


TEI="./$TYPE/$ID.xml"
xmllint --noout --dtdvalid $DTD $TEI
