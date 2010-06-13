#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

BEGIN {
    use lib 't/lib';
    use_ok( 'W3C::XMLSchema' );
}

my $qti = W3C::XMLSchema->new( file => 't/data/imsqti_v2p1.xsd' );

# Just run it somewhere first
my $group0_seq_items = $qti->groups->[0]->sequence->items;

# Run it again on another instance
my $group6_seq_items = eval { $qti->groups->[6]->sequence->items };
if ($@) {
    fail("W3C::XMLSchema::Sequence->items generates exception second time it is executed");
    diag($@);
}
else {
    pass("W3C::XMLSchema::Sequence->items does not generate exception second time it is executed");
}

# Not really needed, but nice to have to verify that the items method
# actually return the right instance

SKIP: {
    skip("item->[0] not defined", 2) unless $group6_seq_items->[0];
    isa_ok( $group6_seq_items->[0], 'W3C::XMLSchema::Element');
    is( $group6_seq_items->[0]->ref, 'areaMapEntry', '6th group sequence item 0 ref mismatch');
}

1;
