#!/usr/bin/perl

# db2solr.pl - make content searchable

# Eric Lease Morgan <emorgan@nd.edu>
# October 17, 2018 - first investigations
# October 20, 2018 - added entities, types, lemmas, and pos


# configure
use constant CARREL   => './carrel';
use constant ETC      => CARREL . '/etc';
use constant DATABASE => ETC . '/carrel.db';
use constant DRIVER   => 'SQLite';
use constant SOLR     => 'http://localhost:8983/solr/carrel';

# require
use DBI;
use strict;
use WebService::Solr;

# sanity check
my $key = $ARGV[ 0 ];
if ( ! $key ) { die "Usage: $0 <key>\n" }

# initialize
my $driver   = DRIVER; 
my $database = DATABASE;
my $dbh      = DBI->connect( "DBI:$driver:dbname=$database", '', '', { RaiseError => 1 } ) or die $DBI::errstr;

# find the given title
my $handle = $dbh->prepare( qq(SELECT * FROM sentences WHERE did='$key';) );
$handle->execute() or die $DBI::errstr;

# process each record
while ( my $results = $handle->fetchrow_hashref ) {

	# parse the data
	my $did      = $$results{ 'did' };
	my $sid      = $$results{ 'sid' };
	my $sentence = $$results{ 'sentence' };

	# build an identifier
	my $id = $did . '_' . $sid;

	# find all entities for in this sentence
	my $subhandle = $dbh->prepare( qq(SELECT * FROM entities WHERE did='$key' AND sid='$sid';) );
	$subhandle->execute() or die $DBI::errstr;
	
	# process the results
	my @entities = ();
	my @types    = ();
	while ( my $subresults = $subhandle->fetchrow_hashref ) {
	
		push( @entities, $$subresults{ 'entity' } );
		push( @types, $$subresults{ 'type' } );
	
	}
	
	# find all lemmas & pos for in this sentence
	my $subhandle = $dbh->prepare( qq(SELECT * FROM tokens WHERE did='$key' AND sid='$sid' AND ( pos IS 'NOUN' OR pos IS 'VERB' OR pos IS 'ADJ' OR pos is 'ADV' OR pos is 'PRON');) );
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
	warn "       did: $did\n";
	warn "       sid: $sid\n";
	warn "        id: $id\n";
	warn "  sentence: $sentence\n";

	# check for entities
	if ( @entities ) {

		# dump some more
		warn "  entities: " . join( '; ', @entities ) . "\n";
		warn "     types: " . join( '; ', @types ) . "\n";
		
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
	my $solr_did       = WebService::Solr::Field->new( 'did'       => $did );
	my $solr_facet_did = WebService::Solr::Field->new( 'facet_did' => $did );
	my $solr_sid       = WebService::Solr::Field->new( 'sid'       => $sid );
	my $solr_id        = WebService::Solr::Field->new( 'id'        => $id );
	my $solr_sentence  = WebService::Solr::Field->new( 'sentence'  => $sentence );

	# fill a solr document with simple fields
	my $doc = WebService::Solr::Document->new;
	$doc->add_fields( $solr_did, $solr_sid, $solr_id, $solr_sentence, $solr_facet_did );

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

