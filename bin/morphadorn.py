#!/usr/bin/env python

# morphadorn.py - given a TEI file, mark-up sentences complete with words, lemmas, and parts-of-speech

# Eric Lease Morgan <eric_morgan@infomotions.com>
# November 24, 2018 - first cut but took all day to write


# configure
MODEL    = 'en'
ENCODING = 'UTF-8'

# require
from lxml import etree
import spacy
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <file>\n" )
	quit()

# initialize
tei = etree.parse( sys.argv[ 1 ] )
nlp = spacy.load( MODEL )

# process each paragraph
for paragraph in tei.xpath( '//body//p' ) :

	# re-initialize
	document       = nlp( paragraph.text )
	paragraph.text = ''
	
	# process each sentence in the given paragraph
	length = len( list( document.sents ) )
	l      = 0
	for sentence in document.sents :

		# increment and (re-)initialize
		l += 1
		i  = 0
		sentence = sentence.as_doc()
		s = etree.SubElement( paragraph, 's' )
		
		# procese each item (token) in the given sentence
		for item in sentence :

			# parse
			token = item.text
			lemma = item.lemma_
			pos   = item.pos_

			# check for punctuation
			if pos == 'PUNCT' : 
				
				# update the xml
				pc = etree.SubElement( s, 'pc' )
				pc.text = token

			# found a word
			else :
				i += 1
				w = etree.SubElement( s, 'w', lemma=lemma, pos=pos )
				if i == 1 : w.text = token
				else : w.text = ' ' + token
		
		# delimit (almost all) sentences
		if l < length : s.tail = ' '
			
# output and done
print( etree.tostring( tei, xml_declaration=True, encoding=ENCODING ).decode( ENCODING ) )
exit()
