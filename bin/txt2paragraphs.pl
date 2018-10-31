#!/usr/bin/perl

# configure
use constant PARAGRAPHS => './paragraphs';

# require
use strict;

# initialize
my $count      = 0;
my $paragraphs = PARAGRAPHS;

# process each line from STDIN
while ( <> ) {

	# parse
	chop;
	my $paragraph = $_;
	
	# increment
	$count++;
	my $filename = sprintf( "%04d", $count );
	
	# open, print, and close
	open( OUT, " > $paragraphs/$filename.txt") or die "Can't open $paragraphs ($!).\n";
	print OUT $paragraph;
	close( OUT );

}

# done
exit;
