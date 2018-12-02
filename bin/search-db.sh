#!/usr/bin/env bash

# search-db.sh - given a number of inputs, query a database

# Eric Lease Morgan <emorgan@nd.edu>
# December 2, 2018 - initial documentation; while in Oslo, OMG


# configure
CARRELS='./carrels'

# sanity check
if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]]; then
	echo "Usage: $0 <name> <NOUN|VERB|ADJ|ADV|etc> <lemma> <PERSON|GPE|LOC|DATE|etc>" >&2
	exit
fi

# get input
NAME=$1
POS=$2
LEMMA=$3
ENITY=$4

# initialize
CARREL="$CARRELS/$NAME"
ETC="$CARREL/etc"
DB="$ETC/$NAME.db"


# count &amp; tabulate pos
echo "Parts-of-speech counts & tabulations"
echo "------------------------------------"
echo "SELECT COUNT( pos ) AS c, pos FROM tokens GROUP BY pos ORDER BY c DESC;" | sqlite3 $DB
echo

# count &amp; tabulate specific pos
echo "Counts & tabulations of lemmas which equal $POS"
echo "---------------------------------------------------"
echo "SELECT COUNT( LOWER ( lemma ) ) AS c, LOWER( lemma ) FROM tokens WHERE pos IS '$POS' GROUP BY LOWER( lemma ) ORDER BY c DESC LIMIT 25;" | sqlite3 $DB
echo

# count & tabulate specific forms of a lemma
echo "All 'de-lemmatized' versions of the word $LEMMA"
echo "---------------------------------------------"
echo "SELECT COUNT( LOWER ( token ) ) AS c, LOWER( token ) from tokens where lemma is '$LEMMA' GROUP BY LOWER( token ) ORDER by c DESC LIMIT 25;" | sqlite3 $DB
echo

# count &amp; tabulate types of entities
echo "Named entity counts & tabulations"
echo "---------------------------------"
echo "SELECT COUNT( type ) AS c, type from entities GROUP BY type ORDER by c DESC;" | sqlite3 $DB
echo

# count &amp; tabulate specific entity type
echo "Counts & tabulations of all $ENITY entities"
echo "-------------------------------------------"
echo "SELECT COUNT( LOWER ( entity ) ) AS c, LOWER( entity ) from entities where type is '$ENITY' GROUP BY LOWER( entity ) ORDER by c DESC LIMIT 25;" | sqlite3 $DB
echo


