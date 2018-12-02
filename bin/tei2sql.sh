#!/usr/bin/env bash

# tei2sql.sh - a front-end to tei2sql.py; generate SQL from a corpus

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first documentation
# December 1, 2018 - modified for a specific carrel and to use parallel; on a plane to Oslo


# configure
CARRELS='./carrels'
TEI2SQL='./bin/tei2sql.py'

# sanity check
if [[ -z "$1" ]]; then
	echo "Usage: $0 <name>" >&2
	exit
fi

# get input
NAME=$1

# initialize
CARREL="$CARRELS/$NAME"
ETC="$CARREL/etc"
SQL="$ETC/$NAME.sql"
TEI="$CARREL/tei"

# do the work
rm -rf $SQL
echo "BEGIN TRANSACTION;" > $SQL
find $TEI -name '*.xml' | parallel $TEI2SQL {} >> $SQL
echo "END TRANSACTION;" >> $SQL

# done
exit
