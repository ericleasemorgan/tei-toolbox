# TEI Toolbox

A set of scripts used to first create TEI files (with BBEdit), parse TEI files, and finally do simple analysis against the result.

## Create a TEI file

Given one or more plain text files, here is a recipe for creating a set of well-formed and valid TEI files which have been enhanced with sentence, word, and part-of-speech tags:

   1. Obtain a plain text file for marking up
   2. Optionally, remove line breaks from the text file
   3. Run ./bin/txt2xml.sh to create the most rudimentary of TEI files
   4. Run ./bin/validate.sh to... validate the TEI
   5. Use what ever tools you have at your disposal to continue marking up the TEI, and this toolbox includes a set of BBEdit macros which may (or may not) make the process easier; Oxygen is a good tool tool
   6. Go to Step #4 until you are finished (or get tired)
   7. Run ./bin/morphadorn.sh to supplement the TEI with parts-of-speech
   8. Run ./bin/validate.sh against the TEI, just to make sure
   9. Go to Step #1 for any number of files -- build a corpus

## Create a "study carrel"

TEI files are merely containers used to do alchemy; TEI turns data into information. Through TEI, numbers, like 1776, are turned into dates. Words, like "man", are turned into nouns. Lists of words might become sentences or titles. Etc. To analyze stand-alone TEI files (or just about any other flavor of XML) it is necessary to have an extensive knowledge XPath, which is a specific XML technology. Sure, additional XML technologies exist, but they are all specific to XML, and compared to the communities of relational databases, full text indexers, general-purpose programming languages, the XML community is small. Thus, it behooves the student, researcher, or scholar to transform their TEI documents into other data structures where the tools are more amenable to analysis. The following recipe does just that; the following recipe creates a "study carrel" and transforms valid TEI into a number of other formats:

   1. Run ./bin/carrel-initialize.sh to create a new "study carrel"
   2. Copy your newly created TEI file(s) to the tei directory of your newly created study carrel
   3. Run ./bin/carrel-build.sh to transform the TEI into many other data structures
   
The end result will be a directory filled with sets of structured data ready for computer analysis -- "reading". These formats include PDF, documents suitable for printing (and writing in). It includes HTML files suitable for online reading. It includes plain text files in the form of complete works, chapters, or paragraphs, all of which lend themselves to various forms of text mining and searching. It includes a relational database and a semantic index for even more fine-grained investigation. 

TEI files are cool, but TEI files are really only a means to an end. Study carrels are filled with content transformed from TEI files, and the resulting content is very amenable to analysis -- "reading".


## Typical searching 

The newly created study carrel supports at least four typical types of searching: 1) querying a relational database, 2) querying a semantic index, 3) concordancing, and 4) full text indexing.

### Concordancing

A concordancing is one of the oldest of text mining processes, and such a tool is often called a "keyword in content" (KWIC) index. Given a word (or regular expression), the concordance will output matching lines as well as a simple dispersion chart. For example:

   1. Run ./bin/search-kwik.pl without any input to learn what input the script takes
   2. Run ./bin/search-kwik.pl with a file from the txt directory of your study carrel as input
   3. Go to Step #2 until you get tired

### Database searching

The study carrel includes a relational database file. The database contains a list of each and every word, part-of-speech, and named-entity from each and every paragraph of your entire corpus. Given a knowledge of the database's structure as well as the codes used to denote parts-of-speech or named-entities, it is possible to query the database not only for individual words but also in terms of grammars. "Find all ways the king is described." The included script only outputs counts & tabulations based on words and their lemmas and types of named-entities. For example:

   1. Run ./bin/search-db.sh without any input to learn what input the script takes
   2. Run ./bin/search-db.sh with the name of your carrel and additional inputs such as "NOUN love PERSON"
   3. Go to Step #2 until you get tired, and after repeated uses, you will see patterns

### Semantic indexing

The study carrel also includes a semantic index -- a list of words and associated vectors. Given a word, the semantic index will determine what other words have similar vectors. For example:

  1. Run ./bin/search-vec.py sans any input to get an idea of what input is expected
  2. Run ./bin/search-vec.py with the name of your study carrel and a word; the result will be a list of words an associated scores, and higher scores denote higher degrees of similarity
  3. Go to Step #2 until you get tired

Semantic indexing only really works with "large" volumes of text, and things start to get large at 1,000,000 words. Other things can be done with semantic indexes such as the completion of analogies or the listing of opposites. The included script only supports similarity.

### Full text indexing

A study carrel is primed for full text indexing with an indexer called Solr. [INSERT HERE THE LONG & COMPLICATED RECIPE OUTLINING HOW TO CREATE THE FULL TEXT INDEX.]



--- 
Eric Lease Morgan &lt;emorgan@nd.edu&gt;   
February 12, 2020

