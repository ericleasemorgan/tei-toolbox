#!/usr/bin/env bash

# sql2db.sh - given a set of previously created SQL statements, create and fill a (SQLite) database

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first documentation


# configure
CARRELS='./carrels'
SCHEMA='./etc/schema.sql'

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
DB="$ETC/$NAME.db"

# do the work
rm -rf $DB
cat $SCHEMA | sqlite3 $DB
cat $SQL    | sqlite3 $DB

# done
exit
