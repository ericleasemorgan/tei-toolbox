#!/usr/bin/env perl

# solr-carrel-delete.pl - remove a carrel a solr index

# Eric Lease Morgan <emorgan@nd.edu>
# December 11, 2018 - first cut; "Happy Birthday, Lincoln!"


# configure
use constant SOLR => 'http://localhost:8983/solr/carrels-tei';

# require
use strict;
use WebService::Solr;

# initialize;
my $solr = WebService::Solr->new( SOLR );

# sanity check
my $carrel = $ARGV[ 0 ];
if ( ! $carrel ) { die "Usage: $0 <carrel>\n" }

# solrize query
my $query = "carrel:$carrel";

# do the work
print "Deleting records matching $query...\n";
$solr->delete_by_query( "$query" );

# done
exit;
