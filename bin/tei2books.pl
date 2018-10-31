#!/usr/bin/perl

# tei2books.pl - create files based on chapters in a TEI file

# Eric Lease Morgan <eric_morgan@infomotions.com>
# September 30, 2016 - while in St. Louis for an Early Print Project meeting


# configure
use constant BOOKS => './books';
use constant TEI   => '/Users/eric/desktop/homer-odyssey/mets/homer-odyssey.xml';

# require
use strict;
use XML::XPath;

# initialize
my $xpath = XML::XPath->new( filename => TEI );
my $count = 0;

# get and process each chapter
my $chapters = $xpath->find( '//div[@type="book"]' );
foreach my $chapter ( $chapters->get_nodelist ) {

	# create a filename based on chapter heading
	my $filename =  $chapter->find( './head' );
	$filename    =~ s/\W//g;
	$count++;
	$filename    =  sprintf( '%02d', $count ) . '-' . $filename . '.txt';
	
	# open, save, and close a file
	open( OUT, ' > ' . BOOKS . "/$filename" ) or die "Can't open file ($!). Call Eric.\n";
	print OUT $chapter->string_value, "\n";
	close OUT;
	
}

# done
exit;
