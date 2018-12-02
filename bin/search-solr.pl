#!/usr/bin/perl

# search.pl - command-line interface to search a solr instance

# Eric Lease Morgan <emorgan@nd.edu>
# October 17, 2018 - first cut
# October 20, 2018 - added entities, types, lemmas, and pos


# configure
use constant ROWS       => 10;
use constant SOLR       => 'http://localhost:8983/solr/carrel';
use constant FACETFIELD => ( 'facet_did', 'facet_type', 'facet_entity', 'facet_lemma', 'facet_pos' );

# require
use strict;
use WebService::Solr;

# get input; sanity check
my $query = $ARGV[ 0 ];
if ( ! $query ) { die "Usage: $0 <query>\n" }

# initialize
my $solr = WebService::Solr->new( SOLR );

# build the search options
my %search_options = ();
$search_options{ 'rows' }        = ROWS;
$search_options{ 'facet.field' } = [ FACETFIELD ];
$search_options{ 'facet' }       = 'true';

# search
my $response = $solr->search( $query, \%search_options );

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


# get the total number of hits
my $total = $response->content->{ 'response' }->{ 'numFound' };

# get number of hits returned
my @hits = $response->docs;

# start the output
print "Your search found $total item(s) and " . scalar( @hits ) . " items(s) are displayed.\n\n";
print '     did facets: ', join( '; ', @facet_did ), "\n\n";
print '     pos facets: ', join( '; ', @facet_pos ), "\n\n";
print '    type facets: ', join( '; ', @facet_type ), "\n\n";
print '  entity facets: ', join( '; ', @facet_entity ), "\n\n";
print '   lemma facets: ', join( '; ', @facet_lemma ), "\n\n";

# loop through each document
for my $doc ( $response->docs ) {
	
	# parse
	my $did      = $doc->value_for( 'did' );
	my $sid      = $doc->value_for( 'sid' );
	my $id       = $doc->value_for( 'id' );
	my $sentence = $doc->value_for( 'sentence' );
	my @entities = $doc->values_for( 'entity' );
	my @types    = $doc->values_for( 'type' );
	my @lemmas   = $doc->values_for( 'lemma' );
	my @pos      = $doc->values_for( 'pos' );
					
	# output
	#print "       did: $did\n";
	#print "       sid: $sid\n";
	print "        id: $id\n";
	print "  sentence: $sentence\n";

	# check for entities
	if ( @entities ) {
	
		print "  entities: " . join( '; ', @entities ) . "\n";
		print "     types: " . join( '; ', @types ) . "\n";
		
	}
	
	# check for entities
	if ( @lemmas ) {
	
		print "    lemmas: " . join( '; ', @lemmas ) . "\n";
		print "       pos: " . join( '; ', @pos ) . "\n";
		
	}
	
	# delimit
	print "\n";
	
}

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




