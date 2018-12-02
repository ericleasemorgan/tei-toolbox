#!/usr/bin/env python

# tei2sql.py - given a TEI file, output sets of SQL statements

# Eric Lease Morgan <eric_morgan@infomotions.com>
# December 1, 2018 - first cut; on a plane to Oslo


# configure
MODEL = 'en'

# require
from lxml import etree
import re
import spacy
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <file>\n" )
	quit()

# initialize
tei = etree.parse( sys.argv[ 1 ] )
nlp = spacy.load( MODEL )

# compute a document id and output
did = tei.xpath( '/TEI/teiHeader/fileDesc/publicationStmt/idno' )[ 0 ].text
print( "INSERT INTO documents ( did ) VALUES ( '" + did + "' );" )

# process each sentence
for sentence in tei.xpath( '//s' ) :
	
	# re-initialize
	sid  = sentence.xpath( './@xml:id' )[ 0 ]
	text = ''
	tid  = 0
	
	# process each token in the sentence
	for item in sentence.xpath( './/w | .//pc' ) :
		
		# increment and parse
		tid   += 1
		token  = item.xpath( 'normalize-space(.)' )
		lemma  = item.xpath( './@lemma' )[ 0 ]
		pos    = item.xpath( './@pos' )[ 0 ]
		
		# escape
		token = re.sub( "'", "''", token )
		lemma = re.sub( "'", "''", lemma )

		# output 
		print( "INSERT INTO tokens ( did, sid, tid, token, lemma, pos ) VALUES ( '%s', '%s', '%s', '%s', '%s', '%s' );" % ( did, sid, str( tid ), token, lemma, pos ) )
		
		# build the sentence
		text = text + item.text

	# extract named entities from the text; better if they were in the xml
	sentence = nlp( text )
	eid      = 0
	for item in sentence.ents :
		
		# increment, parse, and output
		eid    += 1
		entity  = item.text
		entity  = re.sub( "'", "''", entity )
		type    = item.label_
		print( "INSERT INTO entities ( did, sid, eid, entity, type ) VALUES ( '%s', '%s', '%s', '%s', '%s' );" % ( did, sid, str( eid), entity, type ) )

	# escape and output
	text  = re.sub( "'", "''", text )
	print( "INSERT INTO sentences ( did, sid, sentence ) VALUES ( '%s', '%s', '%s' );" % ( did, sid, text ) )

# done
exit()
