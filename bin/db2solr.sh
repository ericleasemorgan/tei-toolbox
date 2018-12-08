#!/usr/bin/env bash

# db2solr.sh - given a file name, run db2solr.pl
# usage: find /Users/eric/Desktop/study-carrel -name *.txt -exec ./bin/db2solr.sh {} \;

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first cut


# configure
DB2SOLR='./bin/db2solr.pl'

# sanity check
if [[ -z "$1" || -z "$2" ]]; then
	echo "Usage: $0 <carrel> <key | file>" >&2
	exit
fi


# get input
CARREL=$1
FILE=$2

# make sane
ID=$( basename "$FILE" .xml )

# do the work
$DB2SOLR $CARREL $ID
