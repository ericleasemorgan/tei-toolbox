#!/usr/bin/perl

# search-ideas.pl - search texts and rank results according to tfidf and "great idea coefficient"

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 25, 2009 - first investigations; based on search.pl
# November 22, 2018 - fixed call to both corpus and rank to include a directory
# December 7, 2018 - added ability to supply one's own lexicon


# define
use constant STOPWORDS => './etc/stopwords.txt';

# use/require
use strict;
require './etc/tfidf-toolbox.pl';

# get the input
my $directory = $ARGV[ 0 ];
my $lexicon   = $ARGV[ 1 ];
my $query     = lc( $ARGV[ 2 ] );
if ( ! $directory or ! $lexicon or ! $query ) { die "Usage: $0 <directory> <lexicon> <word>\n" }

# index, sans stopwords
my %index = ();
foreach my $file ( &corpus( $directory ) ) { $index{ $file } = &index( $file, &slurp_words( STOPWORDS ) ) }

# search
my ( $hits, @files ) = &search( \%index, $query );
print "Your search found $hits hit(s)\n";

# rank
my $ranks = &rank( \%index, [ @files ], $query, $directory );

# great idea coefficients
my $coefficients = &great_ideas( \%index, [ @files ], &slurp_words( $lexicon ) );

# combine ranks and coefficients
my %scores = ();
foreach ( keys %$ranks ) { $scores{ $_ } = $$ranks{ $_ } + $$coefficients{ $_ } }

# sort by score and display
foreach ( sort { $scores{ $b } <=> $scores{ $a } } keys %scores ) {

	print "\t", $scores{ $_ }, "\t", $_, "\n"
	
}

# done, even more fun with tfidf
print "\n";
exit;


