#!/usr/bin/env bash

# carrel-initialize.sh - given a name, create a study carrel

# Eric Lease Morgan <eric_morgan@infomotions.com>
# December 1, 2018 - first cut; on a plane to Oslo


# configure
CARRELS='./carrels'

# sanity check
if [[ -z "$1" ]]; then
	echo "Usage: $0 <name>" >&2
	exit
fi

# get input
NAME=$1

# initialize
CARREL="$CARRELS/$NAME"

# build file system; do the work
mkdir "$CARREL"
mkdir "$CARREL/etc"
mkdir "$CARREL/fo"
mkdir "$CARREL/html"
mkdir "$CARREL/pdf"
mkdir "$CARREL/tei"
mkdir "$CARREL/txt"

# done
exit
