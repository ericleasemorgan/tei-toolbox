#!/usr/bin/env python

# txt2ent.py - given a plain text file, output a tab-delimited file of named entitites

# require
from nltk import *
import os
import re
import spacy
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <file>\n" )
	quit()

# initialize
file = sys.argv[ 1 ]
nlp  = spacy.load( 'en' )

# limit ourselves is a few processors only
#os.system( "taskset -pc 0-1 %d > /dev/null" % os.getpid() )

# open the given file and unwrap it
handle = open( file, 'r' )
text   = handle.read()
text   = re.sub( '\r', '\n', text )
text   = re.sub( '\n+', ' ', text )
text   = re.sub( ' +', ' ', text )
text   = re.sub( '^\W+', '', text )

# begin output
print( "\t".join( [ 'id', 'sid', 'eid', 'entity', 'type' ] ) )

# parse the text into sentences and process each one
key = os.path.splitext( os.path.basename( file ) )[0]
s = 0
for sentence in sent_tokenize( text ) :

	# (re-)initialize and increment
	s += 1
	e = 0
	sentence = nlp( sentence )
	
	# process each entity
	for entity in sentence.ents : 
	
		e += 1
		print( "\t".join( [ key, str( s ), str( e ), entity.text, entity.label_ ] ) )

# done
quit()
