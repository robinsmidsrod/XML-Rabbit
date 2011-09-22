#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

my $qti = MyXSD->new( file => 't/data/imsqti_v2p1.xsd' );
can_ok($qti, 'element_map');
my $element_map = $qti->element_map;
is( scalar keys %{ $element_map }, 254, 'element_map keys mismatch');
is( $element_map->{'a'}, 'a.Type', 'element_map{a} type mismatch');

BEGIN {
    package MyXSD;
    use XML::Rabbit::Root;

    has '+namespace_map' => (
        default => sub { {
            'xsd' => 'http://www.w3.org/2001/XMLSchema',
        } }
    );

    has_xpath_value_map 'element_map' => '//xsd:element[@name]',
        './@name' => './@type',
    ;

    no Moose;
    __PACKAGE__->meta->make_immutable();

}

1;
