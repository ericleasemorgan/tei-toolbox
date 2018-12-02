#!/usr/bin/env bash

# carrel-build.sh - given a name, build a study carrel

# Eric Lease Morgan <eric_morgan@infomotions.com>
# December 1, 2018 - first cut; on a plane to Oslo


# configure
CARRELS='./carrels'

# sanity check
if [[ -z "$1" || -z "$2" ]]; then
	echo "Usage: $0 <name> <word>" >&2
	exit
fi

# get input
NAME=$1
QUERY=$2

# initialize
CARREL="$CARRELS/$NAME"

# do the work
find $CARREL -name *.xml | parallel ./bin/tei2txt.sh  {} $NAME
find $CARREL -name *.xml | parallel ./bin/tei2html.sh {} $NAME
find $CARREL -name *.xml | parallel ./bin/tei2pdf.sh  {} $NAME
./bin/tei2sql.sh    $NAME
./bin/sql2db.sh     $NAME
./bin/report.sh     $NAME
./bin/carrel2vec.sh $NAME
./bin/search-vec.py $NAME $QUERY

# done
exit
