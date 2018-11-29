#!/usr/bin/perl

# tei2chapters.pl - create files based on chapters in a TEI file

# Eric Lease Morgan <eric_morgan@infomotions.com>
# September 30, 2016 - while in St. Louis for an Early Print Project meeting
# October 29, 2018   - added command-line input
# November 25, 2018  - changed shape of filename


use constant SUFFIXES => ( '.xml' );

# require
use strict;
use XML::XPath;
use File::Basename;

# get input
my $xml       = $ARGV[ 0 ];
my $directory = $ARGV[ 1 ];

# sanity check
if ( ! $xml or ! $directory ) { die "Usage: $0 <xml file> <output directory\n" }

# initialize
my $xpath    = XML::XPath->new( filename => $xml );
my $count    = 0;
my $basename = basename( $xml, SUFFIXES );

# get and process each chapter
my $chapters = $xpath->find( '//body//div' );
foreach my $chapter ( $chapters->get_nodelist ) {

	# create a filename 
	$count++;
	my $filename    =  $basename . '_' . sprintf( '%02d', $count ) . '.txt';
	
	# open, save, and close a file
	open( OUT, " > $directory/$filename" ) or die "Can't open file ($!). Call Eric.\n";
	print OUT $chapter->string_value, "\n";
	close OUT;
	
}

# done
exit;
