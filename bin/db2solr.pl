#!/usr/bin/perl

# db2solr.pl - make content searchable

# Eric Lease Morgan <emorgan@nd.edu>
# October 17, 2018 - first investigations
# October 20, 2018 - added entities, types, lemmas, and pos


# configure
use constant CARRELS  => './carrels';
use constant ETC      => '/etc';
use constant DRIVER   => 'SQLite';
use constant SOLR     => 'http://localhost:8983/solr/carrels-tei';

# require
use DBI;
use strict;
use WebService::Solr;

# sanity check
my $name = $ARGV[ 0 ];
my $key  = $ARGV[ 1 ];
if ( ! $name or ! $key ) { die "Usage: $0 <carrel> <key>\n" }

# initialize
my $carrel   = CARRELS . "/$name";
my $database = $carrel . ETC . "/$name.db";
my $driver   = DRIVER; 
my $dbh      = DBI->connect( "DBI:$driver:dbname=$database", '', '', { RaiseError => 1 } ) or die $DBI::errstr;

# find the given title
my $handle = $dbh->prepare( qq(SELECT * FROM paragraphs WHERE did='$key';) );
$handle->execute() or die $DBI::errstr;

# process each record
while ( my $results = $handle->fetchrow_hashref ) {

	# parse the data
	my $did       = $$results{ 'did' };
	my $pid       = $$results{ 'pid' };
	my $paragraph = $$results{ 'paragraph' };
	
	# build an identifier
	my $id = $did . '_' . $pid;

	# find all entities for in this sentence
	my $subhandle = $dbh->prepare( qq(SELECT * FROM entities WHERE did='$key' AND pid='$pid';) );
	$subhandle->execute() or die $DBI::errstr;
	
	# process the results
	my @entities = ();
	my @types    = ();
	while ( my $subresults = $subhandle->fetchrow_hashref ) {
	
		push( @entities, $$subresults{ 'entity' } );
		push( @types, $$subresults{ 'type' } );
		
	
	}
	
	# find all specific types of entities
	my %types = ();
	foreach my $type ( @types ) {
	
		$subhandle = $dbh->prepare( qq(SELECT * FROM entities WHERE did='$key' AND pid='$pid' AND type='$type';) );
		$subhandle->execute() or die $DBI::errstr;

		my @items = ();
		while ( my $subresults = $subhandle->fetchrow_hashref ) { push( @items, $$subresults{ 'entity' } ) }
		$types{ $type } = \@items;
		
	}

	# find all lemmas & pos for in this sentence
	my $subhandle = $dbh->prepare( qq(SELECT * FROM tokens WHERE did='$key' AND pid='$pid' AND ( pos IS 'NOUN' OR pos IS 'VERB' OR pos IS 'ADJ' OR pos is 'ADV' OR pos is 'PRON');) );
	$subhandle->execute() or die $DBI::errstr;
	
	# process the results
	my @lemmas = ();
	my @pos    = ();
	while ( my $subresults = $subhandle->fetchrow_hashref ) {
	
		push( @lemmas, $$subresults{ 'lemma' } );
		push( @pos,    $$subresults{ 'pos' } );
	
	}
	
	# debug; dump
	binmode( STDOUT, ':utf8' );
	warn "     carrel: $name\n";
	warn "        did: $did\n";
	warn "        pid: $pid\n";
	warn "         id: $id\n";
	warn "  paragraph: $paragraph\n";

	# check for entities
	if ( @entities ) {

		# dump some more
		warn "  entities: " . join( '; ', @entities ) . "\n";
		warn "     types: " . join( '; ', @types ) . "\n";
		
	}
	
	# specific entity types
	foreach my $type ( keys( %types ) ) {
	
		my $items = $types{ $type };		
		warn "     $type: " . join( '; ', sort( @$items ) ) . "\n";
			
	}
	
	# check for lemmas
	if ( @lemmas ) {

		# dump some more
		warn "    lemmas: " . join( '; ', @lemmas ) . "\n";
		warn "       pos: " . join( '; ', @pos ) . "\n";
		
	}
	
	# delimit
	warn "\n";
	
	# initialize indexing
	my $solr           = WebService::Solr->new( SOLR );
	my $solr_carrel    = WebService::Solr::Field->new( 'carrel'    => $name );
	my $solr_did       = WebService::Solr::Field->new( 'did'       => $did );
	my $solr_facet_did = WebService::Solr::Field->new( 'facet_did' => $did );
	my $solr_pid       = WebService::Solr::Field->new( 'pid'       => $pid );
	my $solr_id        = WebService::Solr::Field->new( 'id'        => $id );
	my $solr_paragraph = WebService::Solr::Field->new( 'paragraph' => $paragraph );

	# fill a solr document with simple fields
	my $doc = WebService::Solr::Document->new;
	$doc->add_fields( $solr_carrel, $solr_did, $solr_pid, $solr_id, $solr_paragraph, $solr_facet_did );

	# add complex fields
	foreach ( @entities ) {

		$doc->add_fields(( WebService::Solr::Field->new( 'entity'       => $_ )));
		$doc->add_fields(( WebService::Solr::Field->new( 'facet_entity' => $_ )));
	
	}

	# add complex fields
	foreach ( @types ) {

		$doc->add_fields(( WebService::Solr::Field->new( 'type'       => $_ )));
		$doc->add_fields(( WebService::Solr::Field->new( 'facet_type' => $_ )));
	
	}

	# add persons
	my $persons = $types{ 'PERSON' };
	foreach ( @$persons ) {

		$doc->add_fields(( WebService::Solr::Field->new( 'person'       => $_ )));
		$doc->add_fields(( WebService::Solr::Field->new( 'facet_person' => $_ )));
	
	}

	# add gpe
	my $gpes = $types{ 'GPE' };
	foreach ( @$gpes ) {

		$doc->add_fields(( WebService::Solr::Field->new( 'gpe'       => $_ )));
		$doc->add_fields(( WebService::Solr::Field->new( 'facet_gpe' => $_ )));
	
	}

	# add loc
	my $locs = $types{ 'LOC' };
	foreach ( @$locs ) {

		$doc->add_fields(( WebService::Solr::Field->new( 'loc'       => $_ )));
		$doc->add_fields(( WebService::Solr::Field->new( 'facet_loc' => $_ )));
	
	}

	# add complex fields
	foreach ( @lemmas ) {

		$doc->add_fields(( WebService::Solr::Field->new( 'lemma'       => $_ )));
		$doc->add_fields(( WebService::Solr::Field->new( 'facet_lemma' => $_ )));
	
	}

	# add complex fields
	foreach ( @pos ) {

		$doc->add_fields(( WebService::Solr::Field->new( 'pos'       => $_ )));
		$doc->add_fields(( WebService::Solr::Field->new( 'facet_pos' => $_ )));
	
	}

	# save/index
	$solr->add( $doc );
	
}

# done
exit;

