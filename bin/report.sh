#!/usr/bin/env bash



DB='./etc/study-carrel.db'
POS='NOUN'
LEMMA='father'
ENITY='PERSON'

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

# count &amp; tabulate specific forms of a lemma
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

