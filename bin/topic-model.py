#!/usr/bin/env python

# topic-model.py - given a hard-coded directory of files, output "themes" and documents associated with them

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first documentation; written in Benejarafe Alto (Spain) at La Finca


# configure
TOPICS     = 4
DIMENSIONS = 7
ITERATIONS = 40
EXTRAS     = [ 'upon', 'would', 'one', 'though', 'could', 'yet', 'thy', 'shall', 'still', 'u' ]

# require
from gensim import corpora
from nltk.corpus import stopwords 
from nltk.stem.wordnet import WordNetLemmatizer
import gensim
import os
import re
import string
import sys
import pyLDAvis.gensim

# define
def clean( document ):
	features = document.lower()
	features = [ feature for feature in features.split() if feature not in stopwords ]	
	features = [ feature for feature in features if feature.isalpha() ]
	features = [ lemma.lemmatize( feature ) for feature in features ]
	return features

# sanity check
if len( sys.argv ) != 2 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <directory>\n" )
	exit()


# initialize
lemma     = WordNetLemmatizer()
stopwords = stopwords.words( 'english' )
for word in EXTRAS : stopwords.append( word )

# given a directory of files, create and normalize a set of documents
directory = sys.argv[ 1 ]
documents = []
for item in os.listdir( directory ) :
	file = os.path.join( directory, item )
	if os.path.isfile( file ) : documents.append( clean( open( file ).read() ) )
	
# create a dictionary from the documents, and then a term matrix
dictionary = corpora.Dictionary( documents )
matrix     = [ dictionary.doc2bow( document ) for document in documents ]

# initialize an LDA model, and then do the work
lda   = gensim.models.ldamodel.LdaModel
model = lda( matrix, num_topics = TOPICS, id2word = dictionary, passes = ITERATIONS )

# output each topic in the resulting model
for topic in model.show_topics( num_topics = -1, num_words = DIMENSIONS, formatted = False ) :
	id = topic[ 0 ]
	print( id )
	for item in topic[ 1 ] :
		word  = item[ 0 ]
		score = item[ 1 ]
		print( '  ' + word + ' (' + str( score ) + ')' )
		
# output cool interactive graphic of results
pyLDAvis.show( pyLDAvis.gensim.prepare( model, matrix, dictionary, sort_topics=True ) )

# discover what topic is most associated with each of the given documents
for item in os.listdir( directory ) :
	file = os.path.join( directory, item )
	if os.path.isfile( file ) :
		matrix = dictionary.doc2bow( clean( open( file ).read() ) )
		print( file, model.get_document_topics( matrix ) )
	
# done
exit()


