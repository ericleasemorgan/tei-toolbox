#!/usr/bin/env python

# documents2vec.py - given a process and/or a file, initialize, update, or close a semantic (word2vec) INDEX

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first documentation, but written on an airplane from Chicago to Madrid


# configure
MODEL   = 'en'
INDEX   = './etc/carrel.vec'
MINIMUM = 2
SIZE    = 50
SG      = 1

# require
from gensim.models import KeyedVectors
from gensim.models import Word2Vec
from nltk.corpus import stopwords
import os
import re
import spacy
import sys

# sanity check
if len( sys.argv ) != 3 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <new|update|finish> <file>\n" )
	exit()

# check for finishing off
process = sys.argv[ 1 ]
if process == 'finish' :
	index = Word2Vec.load( INDEX )
	index.wv.save( INDEX )
	exit()

# import the data file and normalize it
data = open( sys.argv[ 2 ] ).read()
data = re.sub( '\r+', ' ', data )
data = re.sub( '\n+', ' ', data )
data = re.sub( ' +' , ' ', data )
data = re.sub( '^\W+', '', data )
data = re.sub( '$\W+', '', data )

# model the data
nlp      = spacy.load( MODEL )
document = nlp( data )

# initialize the stop words and the sentences
stopwords = stopwords.words( 'english' )
sentences = []

# process each sentence in the document
for sentence in document.sents :
	
	# transform the sentence into a document and extract its features
	text     = sentence.as_doc()
	features = [ feature.text for feature in text ]
	
	# remove the undesirables, and update the list of sentences
	features = [ feature for feature in features if feature.isalpha() ]
	features = [ feature for feature in features if feature not in stopwords ]
	features = [ feature.lower() for feature in features ]
	sentences.append( features )

# do the work, or else
if process == 'new' :
	index = Word2Vec( sentences, size = SIZE, min_count = MINIMUM, sg = SG )	
	index.save( INDEX )

elif process == 'update' :
	index = Word2Vec.load( INDEX )
	index.train( sentences, total_examples = index.corpus_count, epochs = index.epochs )
	index.save( INDEX )

else : sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <new|update|finish> <file>\n" )

# done
exit()
