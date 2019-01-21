#!/usr/bin/env perl

# search-solr.pl - command-line interface to search a solr instance

# Eric Lease Morgan <emorgan@nd.edu>
# October 17, 2018  - first cut
# October 20, 2018  - added entities, types, lemmas, and pos
# December 6, 2018  - added hypertext links and ability to specify number of hits
# December 11, 2018 - adding more facets


# configure
use constant ROWS       => 3;
use constant SOLR       => 'http://localhost:8983/solr/carrels-tei';
use constant FACETFIELD => ( 'facet_did', 'facet_type', 'facet_entity', 'facet_lemma', 'facet_pos', 'facet_person', 'facet_loc', 'facet_gpe' );
use constant URL        => 'file:///Users/emorgan/Documents/tei-toolbox/carrels/##CARREL##/html';
use constant HEADER     => "did\tpid\tparagraph\n";

# require
use strict;
use WebService::Solr;

# get input; sanity check
my $carrel = $ARGV[ 0 ];
my $query  = $ARGV[ 1 ];
my $rows   = $ARGV[ 2 ];
my $format = $ARGV[ 3 ];
if ( ! $carrel or ! $query or ! $rows or ! $format ) { die "Usage: $0 <carrel> <query> <integer> <summary|terse|full|csv|html>\n" }

# initialize
my $solr =  WebService::Solr->new( SOLR );

# build the search options
my %search_options = ();
$search_options{ 'rows' }        = $rows;
$search_options{ 'facet.field' } = [ FACETFIELD ];
$search_options{ 'facet' }       = 'true';

# search
my $response = $solr->search( "($query) AND carrel:$carrel", \%search_options );

# build a list of did facets
my @facet_did = ();
my $did_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_did } );
foreach my $facet ( sort { $$did_facets{ $b } <=> $$did_facets{ $a } } keys %$did_facets ) { push @facet_did, $facet . ' (' . $$did_facets{ $facet } . ')'; }

# build a list of type facets
my @facet_type = ();
my $type_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_type } );
foreach my $facet ( sort { $$type_facets{ $b } <=> $$type_facets{ $a } } keys %$type_facets ) { push @facet_type, $facet . ' (' . $$type_facets{ $facet } . ')'; }

# build a list of entity facets
my @facet_entity = ();
my $entity_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_entity } );
foreach my $facet ( sort { $$entity_facets{ $b } <=> $$entity_facets{ $a } } keys %$entity_facets ) { push @facet_entity, $facet . ' (' . $$entity_facets{ $facet } . ')'; }

# build a list of lemma facets
my @facet_lemma = ();
my $lemma_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_lemma } );
foreach my $facet ( sort { $$lemma_facets{ $b } <=> $$lemma_facets{ $a } } keys %$lemma_facets ) { push @facet_lemma, $facet . ' (' . $$lemma_facets{ $facet } . ')'; }

# build a list of pos facets
my @facet_pos = ();
my $pos_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_pos } );
foreach my $facet ( sort { $$pos_facets{ $b } <=> $$pos_facets{ $a } } keys %$pos_facets ) { push @facet_pos, $facet . ' (' . $$pos_facets{ $facet } . ')'; }

# build a list of person facets
my @facet_person = ();
my $person_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_person } );
foreach my $facet ( sort { $$person_facets{ $b } <=> $$person_facets{ $a } } keys %$person_facets ) { push @facet_person, $facet . ' (' . $$person_facets{ $facet } . ')'; }

# build a list of LOC facets
my @facet_loc = ();
my $loc_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_loc } );
foreach my $facet ( sort { $$loc_facets{ $b } <=> $$loc_facets{ $a } } keys %$loc_facets ) { push @facet_loc, $facet . ' (' . $$loc_facets{ $facet } . ')'; }

# build a list of LOC facets
my @facet_gpe = ();
my $gpe_facets = &get_facets( $response->facet_counts->{ facet_fields }->{ facet_gpe } );
foreach my $facet ( sort { $$gpe_facets{ $b } <=> $$gpe_facets{ $a } } keys %$gpe_facets ) { push @facet_gpe, $facet . ' (' . $$gpe_facets{ $facet } . ')'; }

# get the total number of hits
my $total = $response->content->{ 'response' }->{ 'numFound' };

# get number of hits returned
my @hits = $response->docs;

# initialize the links
my $url =  URL;
$url    =~ s/##CARREL##/$carrel/;

# start the output; full/everything
if ( $format eq 'full' ) {

	print "Your search found $total item(s) and " . scalar( @hits ) . " items(s) are displayed.\n\n";
	print '       did facets: ', join( '; ', @facet_did ), "\n\n";
	print '       pos facets: ', join( '; ', @facet_pos ), "\n\n";
	print '      type facets: ', join( '; ', @facet_type ), "\n\n";
	print '    entity facets: ', join( '; ', @facet_entity ), "\n\n";
	print '     lemma facets: ', join( '; ', @facet_lemma ), "\n\n";
	print '    person facets: ', join( '; ', @facet_person ), "\n\n";
	print '       GPE facets: ', join( '; ', @facet_gpe ), "\n\n";
	print '  location facets: ', join( '; ', @facet_loc ), "\n\n";

	# loop through each document
	for my $doc ( $response->docs ) {
	
		# parse
		my $did       = $doc->value_for(  'did' );
		my $pid       = $doc->value_for(  'pid' );
		my $id        = $doc->value_for(  'id' );
		my $url       = "$url/$did.html#$pid";
		my $paragraph = $doc->value_for(  'paragraph' );
		my @entities  = $doc->values_for( 'entity' );
		my @types     = $doc->values_for( 'type' );
		my @lemmas    = $doc->values_for( 'lemma' );
		#my @pos       = $doc->values_for( 'pos' );
					
		# output
		print "        did: $did\n";
		#print "       sid: $sid\n";
		print "        pid: $pid\n";
		print "        url: $url\n";
		print "  paragraph: $paragraph\n";

		# check for entities
		if ( @entities ) {
	
			print "   entities: " . join( '; ', @entities ) . "\n";
			print "      types: " . join( '; ', @types ) . "\n";
		
		}
	
		# check for entities
		if ( @lemmas ) {
	
			print "     lemmas: " . join( '; ', @lemmas ) . "\n";
			#print "       pos: " . join( '; ', @pos ) . "\n";
		
		}
	
		# delimit
		print "\n";
	
	}

}

# summary; total hits plus facet counts
elsif ( $format eq 'summary' ) { 

	print "Your search found $total item(s) and " . scalar( @hits ) . " items(s) are displayed.\n\n";
	print '       did facets: ', join( '; ', @facet_did ), "\n\n";
	print '       pos facets: ', join( '; ', @facet_pos ), "\n\n";
	print '      type facets: ', join( '; ', @facet_type ), "\n\n";
	print '    entity facets: ', join( '; ', @facet_entity ), "\n\n";
	print '     lemma facets: ', join( '; ', @facet_lemma ), "\n\n";
	print '    person facets: ', join( '; ', @facet_person ), "\n\n";
	print '       GPE facets: ', join( '; ', @facet_gpe ), "\n\n";
	print '  location facets: ', join( '; ', @facet_loc ), "\n\n";
	print "\n";
	
}

# html
elsif ( $format eq 'html' ) { 

	# summary
	my $summary = '<ul>';
	$summary = $summary . "<li><b>did</b>: "      . join( '; ', @facet_did )    . '</li>';
	$summary = $summary . "<li><b>pos</b>: "      . join( '; ', @facet_pos )    . '</li>';
	$summary = $summary . "<li><b>type</b>: "     . join( '; ', @facet_type )   . '</li>';
	$summary = $summary . "<li><b>entity</b>: "   . join( '; ', @facet_entity ) . '</li>';
	$summary = $summary . "<li><b>lemma</b>: "    . join( '; ', @facet_lemma )  . '</li>';
	$summary = $summary . "<li><b>person</b>: "   . join( '; ', @facet_person )  . '</li>';
	$summary = $summary . "<li><b>GPE</b>: "      . join( '; ', @facet_gpe )  . '</li>';
	$summary = $summary . "<li><b>location</b>: " . join( '; ', @facet_loc )  . '</li>';
	$summary = $summary . '</ul>';
	
	
	# loop through each document
	my $results = '<ol>';
	for my $doc ( $response->docs ) {
			
		# parse
		my $did       = $doc->value_for(  'did' );
		my $pid       = $doc->value_for(  'pid' );
		my $id        = $doc->value_for(  'id' );
		my $url       = "$url/$did.html#$pid";
		my $paragraph = $doc->value_for(  'paragraph' );
		my @entities  = $doc->values_for( 'entity' );
		my @types     = $doc->values_for( 'type' );
		my @lemmas    = $doc->values_for( 'lemma' );
		#my @pos       = $doc->values_for( 'pos' );
					
		# output
		$results = $results . "<li style='margin-bottom: 1em'>$paragraph";
		$results = $results . "<ul>";
		$results = $results . "<li><b>did</b>: $did</li>";
		$results = $results . "<li><b>pid</b>: <a href='$url'>$pid</a></li>";

		# check for entities
		if ( @entities ) {
	
			$results = $results . "<li><b>entities</b>: " . join( '; ', @entities ) . '</li>';
			$results = $results . "<li><b>types</b>: "    . join( '; ', @types ) . '</li>';
		
		}
	
		# check for entities
		if ( @lemmas ) { $results = $results . "<li><b>lemmas</b>: " . join( '; ', @lemmas ) . '</li>' }
	
		# delimit
		$results = $results . "</ul></li>";
	
	}

	# finish off the search results
	$results = $results . '</ol>';

	# build the output & done
	my $html =  &template;
	$html    =~ s/##TOTAL##/$total/e;
	$html    =~ s/##HITS##/scalar( @hits )/e;
	$html    =~ s/##RESULTS##/$results/e;
	$html    =~ s/##SUMMARY##/$summary/e;
	print $html;

}

# csv
elsif ( $format eq 'csv' ) { 

	# output a header
	print HEADER;

	# loop through each document
	for my $doc ( $response->docs ) {
	
		# parse & output
		my $did       = $doc->value_for( 'did' );
		my $pid       = $doc->value_for( 'pid' );
		my $paragraph = $doc->value_for( 'paragraph' );
		print "$did\t$pid\t$paragraph\n";

	}
	
}

# terse; just paragraphs
elsif ( $format eq 'terse' ) { 

	# loop through each document
	for my $doc ( $response->docs ) {
	
		# parse
		my $paragraph = $doc->value_for(  'paragraph' );
		print "$paragraph\n";
		print "\n";
	
	}

 }

# error
else { die "Usage: $0 <carrel> <query> <integer> <summary|terse|full|csv|html>\n" }

# done
exit;


# convert an array reference into a hash
sub get_facets {

	my $array_ref = shift;
	
	my %facets;
	my $i = 0;
	foreach ( @$array_ref ) {
	
		my $k = $array_ref->[ $i ]; $i++;
		my $v = $array_ref->[ $i ]; $i++;
		next if ( ! $v );
		$facets{ $k } = $v;
	 
	}
	
	return \%facets;
	
}

sub template {

	return <<EOF;
<html>
<head>
<title>Search results</title>
</head>
<body style='margin: 3%'>
<h1>Search results</h1>

<p>Your search found ##TOTAL## item(s) and ##HITS## items(s) are displayed.</p>

<h2>Facets</h2>
##SUMMARY##

<h2>Results</h2>
##RESULTS##

</body>
</html>
EOF

}




