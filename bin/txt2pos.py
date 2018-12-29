#!/usr/bin/env python

# configure
HEADER = "sid\twid\tword\tlemma\tpos"
DATA = "The quick brown fox jumped over the lazy dog. This is a test. This is a test of the Emergency Broadcast System. This is only a test. In case of a real emergency, you would be instructed to contact the nearest systems librarian."

# require
from nltk	import *
from nltk.corpus       import wordnet
from nltk.stem.wordnet import WordNetLemmatizer
import sys

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <file>\n" )
	quit()

def get_wordnet_pos( tag ) :
	if tag.startswith('J')   : return wordnet.ADJ
	elif tag.startswith('V') : return wordnet.VERB
	elif tag.startswith('N') : return wordnet.NOUN
	elif tag.startswith('R') : return wordnet.ADV
	else : return ''

handle     = open( sys.argv[ 1 ], 'r')
data       = handle.read()
 
# initialize and process each sentence
sentences = sent_tokenize( data )
sid       = 0
for sentence in sentences :

	# re-initialize and process each token
	sid    += 1
	tokens =  ( pos_tag( word_tokenize( sentence ) ) )
	wid    =  0
	for token in tokens :

		# parse and output
		wid   += 1
		word  =  token[ 0 ]
		pos   =  token[ 1 ]
		lemma =  ''
		if ( get_wordnet_pos( pos ) ) : lemma = lemmatizer.lemmatize( word, get_wordnet_pos( pos ) )
		print( "\t".join( ( str( sid ), str( wid ), word, lemma, pos ) ) )

# done
exit()
