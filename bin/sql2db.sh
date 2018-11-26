#!/usr/bin/env bash

# sql2db.sh - given a set of previously created SQL statements, create and fill a (SQLite) database

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first documentation


# configure
DB='./etc/carrel.db'
SCHEMA='./etc/schema.sql'
SQL='./etc/carrel.sql'

# do the work
rm -rf $DB
cat $SCHEMA | sqlite3 $DB
cat $SQL    | sqlite3 $DB

# done
exit
