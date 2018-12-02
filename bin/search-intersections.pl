#!/usr/bin/env perl

# search-intersections.pl - extract and count the common ngrams from two texts

# Eric Lease Morgan <eric_morgan@infomotions.com>
# September 11, 2010 - first investigations
# September 12, 2010 - made it more general
# Decemer    2, 2018 - added command-line input


# configure
use constant LENGTH => 10;

# require
use strict;
use Lingua::EN::Ngram;

# get input and sanity check
my $textone = $ARGV[ 0 ];
my $texttwo = $ARGV[ 1 ];
my $length  = $ARGV[ 2 ];
if ( ! $textone or ! $texttwo or  ! $length ) { die "Usage: $0 <a file> <another file> <integer>\n" }

# build corpus
my $ngrams      = Lingua::EN::Ngram->new( file => $textone );
my $moreengrams = Lingua::EN::Ngram->new( file => $texttwo );
my $corpus      = Lingua::EN::Ngram->new;

# calculate intersections
my $intersections = $corpus->intersection( corpus => [ ( $ngrams, $moreengrams ) ], length => $length );

# process each intersection
print 'Top ', LENGTH, " $length-gram phrases common to both ", $textone, ' and ', $texttwo, ":\n";
my $index = 0;
foreach ( sort { $$intersections{ $b } <=> $$intersections{ $a }} keys %$intersections ) {

	# skip punctuation
	next if ( $_ =~ /[,.?!:;()\-]/ );
	next if ( $_ =~ /^'/ or $_ =~ /' / );
	
	# increment
	$index++;
	last if ( $index > LENGTH );
	
	# print summary
	print $$intersections{ $_ }, "\t$_\n";
	
}

# done
exit;


