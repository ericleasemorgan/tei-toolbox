#!/usr/bin/env perl

# search-tfidf.pl - search texts and rank results; based on http://en.wikipedia.org/wiki/Tfidf

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 5, 2009  - first investigations
# April 6, 2009  - prettified code
# April 10, 2009 - required library of subroutines
# April 11, 2009 - added stopwords
# April 12, 2009 - added dynamic corpus


# use/require
use strict;
use Lingua::StopWords qw( getStopWords );
require './etc/tfidf-toolbox.pl';

# get the input
my $directory = $ARGV[ 0 ];
my $q         = lc( $ARGV[ 1 ] );
if ( ! $q ) {

	print "Usage: $0 <directory> <query>\n";
	exit; 

}

# index, sans stopwords
my %index = ();
foreach my $file ( &corpus( $directory ) ) { $index{ $file } = &index( $file, &getStopWords( 'en' ) ) }

# search
my ( $hits, @files ) = &search( \%index, $q );
print "Your search found $hits hit(s)\n";

# rank
my $ranks = &rank( \%index, [ @files ], $q, $directory );

# sort by rank and display
foreach my $file ( sort { $$ranks{ $b } <=> $$ranks{ $a } } keys %$ranks ) {

	print "\t", $$ranks{ $file }, "\t", $file, "\n"
	
}

# done, fun with tfidf
print "\n";
exit;


