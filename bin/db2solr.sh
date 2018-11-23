#!/usr/bin/env bash

# db2solr.sh - given a file name, run db2solr.pl
# usage: find /Users/eric/Desktop/study-carrel -name *.txt -exec ./bin/db2solr.sh {} \;

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first cut


# configure
DB2SOLR='./bin/db2solr.pl'

# get input
FILE=$1

# make sane
ID=$( basename "$FILE" .txt )

# do the work
$DB2SOLR $ID
