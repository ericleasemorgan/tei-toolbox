#!/usr/bin/env bash

# documents2sql.sh - a front-end to documents2sql.py; generate SQL from a corpus

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first documentation


# configure
SQL='./etc/study-carrel.sql'
CORPUS='./study-carrel'
DOCUMENTS2SQL='./bin/documents2sql.py'

# do the work
rm -rf $SQL
echo "BEGIN TRANSACTION;" > $SQL
find $CORPUS -name '*.txt' -exec $DOCUMENTS2SQL {} >> $SQL \;
echo "END TRANSACTION;" >> $SQL

# done
exit
