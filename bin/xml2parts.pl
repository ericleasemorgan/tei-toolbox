#!/usr/bin/perl

# xml2parts.pl - given an xml file, save all chapters (or paragraphs/line groups) to a set of files

# Eric Lease Morgan <emorgan@nd.edu>
# October 21, 2016 - first investigations


# require
use XML::XPath;
use strict;

# get input / sanity check
my $parts     = $ARGV[ 0 ];
my $file      = $ARGV[ 1 ];
my $directory = $ARGV[ 2 ];
if ( ! $parts or ! $file or ! $directory ) {

	print "Usage: $0 <chapters|paragraphs> <XML file> <directory>\n";
	exit;

}

# initialize
my $xpath     = XML::XPath->new( filename => $file );
my $pattern   = '';
if ( $parts eq 'chapters' ) { $pattern = '//div[@type="chapter"]' }
else { $pattern = '//text//p|//text//lg' }

# get the document identifier
my $docid = $xpath->findvalue( '/TEI/teiHeader/fileDesc/publicationStmt/idno' );

# process each section (part)
my $sections = $xpath->find( $pattern );
foreach my $section ( $sections->get_nodelist ) {

	# get the section identifier
	my $cid = $section->findvalue( './@xml:id' );
	
	# save the chapter to a file
	my $filename = "$directory/$docid-$cid.txt";
	open( OUT, " >  $filename" ) or die "Can't open $filename ($!). Call Eric.\n";
	binmode( OUT, ':utf8' );
	print OUT $section->string_value;
	close OUT;
		
}

# done
exit;