#!/usr/bin/env perl


# configure
use constant TEI     => './tei';
use constant SUFFIXES => ( '.xml' );
use constant HEADER   => "id\tauthor\tauathor (sort)\ttitle\ttitle (sort)\tdate\tsize in words\n";

# require
use strict;
use XML::XPath;
use File::Basename;

# initialize
my $directory = TEI;
print HEADER;

# process each item in the configured directory
opendir( DIRECTORY, $directory ) or die "Could not open $directory: $!\n";
while ( my $file = readdir( DIRECTORY ) ) {
  
	# check for desired file type
	my ( $name, $directory, $extention ) = fileparse( $file, SUFFIXES );	
	next if ( $extention ne '.xml' );
	 	
 	# re-initialize
	my $parser = XML::XPath->new( filename => TEI . "/$file" );

	# extract stuff
	my $key           = $parser->find( '/TEI/teiHeader/fileDesc/publicationStmt/idno' );
	my $title_main    = $parser->find( '/TEI/teiHeader/fileDesc/titleStmt/title[@type="main"]' );
	my $title_sort    = $parser->find( '/TEI/teiHeader/fileDesc/titleStmt/title[@type="sort"]' );
	my $author_main   = $parser->find( '/TEI/teiHeader/fileDesc/titleStmt/author/name[@type="main"]' );
	my $author_sort   = $parser->find( '/TEI/teiHeader/fileDesc/titleStmt/author/name[@type="sort"]' );
	my $date_creation = $parser->find( '/TEI/teiHeader/profileDesc/creation/date/@when' );
	my $words         = $parser->find( '//w' )->size;

	# debug
	warn "              key: $key\n";
  	warn "    author (main): $author_main\n";
  	warn "    author (sort): $author_sort\n";
  	warn "     title (main): $title_main\n";
  	warn "     title (sort): $title_sort\n";
  	warn "  date (creation): $date_creation\n";
  	warn "  number of words: $words\n";
  	warn "\n";

	# output
	print "$key\t$author_main\t$author_sort\t$title_main\t$title_sort\t$date_creation\t$words\n";
	
}


# clean up and done
closedir(DIRECTORY);
exit;