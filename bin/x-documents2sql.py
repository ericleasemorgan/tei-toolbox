#!/usr/bin/env python

# document2sql.py - given a file, generate a pile o' sql; index a file

# Eric Lease Morgan <eric_morgan@infomotions.com>
# September 26, 2018 - first cut; on an airplane to Madrid


# configure
MODEL = 'en'

# require
import os
import re
import spacy
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <file>\n" )
	quit()

file = sys.argv[ 1 ]

# import the data file and normalize it
data = open( file ).read()
data = re.sub( '\r+', ' ', data )
data = re.sub( '\n+', ' ', data )
data = re.sub( ' +' , ' ', data )
data = re.sub( '^\W+', '', data )
data = re.sub( '$\W+', '', data )

# compute a document id and output the necessary sql
did  = os.path.basename( os.path.splitext( file )[ 0 ] )
print( "INSERT INTO documents ( did ) VALUES ( '" + did + "' );" )

# model the data
nlp      = spacy.load( MODEL )
document = nlp( data )

# process every sentence
sid = 0
for sentence in document.sents :
	
	# increment, parse, and output
	sid  += 1
	text  = sentence.text
	text  = re.sub( "'", "''", text )
	print( "INSERT INTO sentences ( did, sid, sentence ) VALUES ( '" + did + "', '" + str( sid ) + "', '" + text + "' );" )
	
	# transform and process every entity
	sentence = sentence.as_doc()
	
	# process every entity
	eid  = 0
	for item in sentence.ents :
		
		# increment, parse, and output
		eid    += 1
		entity  = item.text
		entity  = re.sub( "'", "''", entity )
		type    = item.label_
		print( "INSERT INTO entities ( did, sid, eid, entity, type ) VALUES ( '" + did + "', '" + str( sid ) + "', '" + str( eid ) + "', '" + entity  + "', '" + type + "' );" )

	# process every token
	tid = 0
	for item in sentence :

		# increment, parse, and output
		tid += 1
		token = item.text
		token  = re.sub( "'", "''", token )
		lemma = item.lemma_
		lemma  = re.sub( "'", "''", lemma )
		pos   = item.pos_
		print( "INSERT INTO tokens ( did, sid, tid, token, lemma, pos ) VALUES ( '" + did + "', '" + str( sid ) + "', '" + str( tid ) + "', '" + token  + "', '" + lemma + "', '" + pos + "' );" )

	# delimit
	print()

# done
exit()
