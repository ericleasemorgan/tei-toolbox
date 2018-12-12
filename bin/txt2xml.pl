#!/usr/bin/env perl

# txt2xml.pl - given a file name, output a vanilla TEI file; tried shell but too hard; Sue me.


# configure
use constant TEMPLATE  => './etc/template.xml';
use constant DIRECTORY => './xml';

# require
use strict;

# get input
my $file = $ARGV[ 0 ];
my $key  = $ARGV[ 1 ];
if ( ! $file or ! $key) { die "Usage: $0 <file> <key>\n" }

# initialize
my $txt = &slurp( $file );
my $xml = &slurp( TEMPLATE );

# do the necessary substitutions
$xml =~ s/##BODY##/$txt/;
$xml =~ s/##IDNO##/$key/;

# configure output and save
my $output = DIRECTORY . "/$key.xml";
open( XML, " > $output" ) or die "Can't open $output ($!)\n";
print XML $xml;
close( XML );

# done
exit;


sub slurp {

	my $f = shift;
	open ( F, $f ) or die "Can't open $f: $!\n";
	my $r = do { local $/; <F> };
	close F;
	return $r;

}