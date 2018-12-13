#!/usr/bin/env perl

# txt2xml.pl - given a file name, output a vanilla TEI file; tried shell but too hard; Sue me.


# configure
use constant TEMPLATE => './etc/template.xml';

# require
use strict;

# get input
my $file = $ARGV[ 0 ];
my $key  = $ARGV[ 1 ];
if ( ! $file or ! $key) { die "Usage: $0 <file> <key>\n" }

# initialize
my $txt = &slurp( $file );
my $xml = &slurp( TEMPLATE );

# escape necessary entities
$txt =~ s/&/&amp;/g;
$txt =~ s/</&lt;/g;
$txt =~ s/>/&gt;/g;

# build the xml
$xml =~ s/##BODY##/$txt/;
$xml =~ s/##IDNO##/$key/;

# output and don
print $xml;
exit;


sub slurp {

	my $f = shift;
	open ( F, $f ) or die "Can't open $f: $!\n";
	my $r = do { local $/; <F> };
	close F;
	return $r;

}