#!/usr/bin/env bash

# documents2vec.sh - a front-end to documents2vec.py

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October  17, 2018 - first documentation; written on a plane from Madrid to Chicago; brain-dead
# November 23, 2018 - added logic so a whole directory can be processed; baroque-en


# configure 
DIRECTORY='./carrel'
DOCUMENTS2VEC='./bin/documents2vec.py'
INDEX='./etc/carrel.vec'

# initialize; obtuse
rm -rf $INDEX
FILES=( $DIRECTORY/*.txt )

# process each item in the list of files; baroque and rococo 
SIZE=${#FILES[@]}
for (( I=1; I<$SIZE+1; I++ )); do

	if [[ $I -eq 1 ]]; then
		COMMAND="$DOCUMENTS2VEC new ${FILES[$I-1]}"
	elif [[ $I -lt $SIZE+1 ]]; then
		COMMAND="$DOCUMENTS2VEC update ${FILES[$I-1]}"
	fi
  
  	# debug and do the work
  	echo "$I $COMMAND"
  	$COMMAND
  	
done

# close the index and done
COMMAND="$DOCUMENTS2VEC finish fini"
echo "$I $COMMAND"
$COMMAND
exit

