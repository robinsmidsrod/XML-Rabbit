#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 8;

my $qti = MyXSD->new( file => 't/data/imsqti_v2p1.xsd' );

can_ok($qti, 'element_map');
my $element_map = $qti->element_map;
is( scalar keys %{ $element_map }, 254, 'element_map keys mismatch');
is( $element_map->{'a'}->type, 'a.Type', 'element_map->{a} type mismatch');

can_ok($qti, 'element_and_group_map');
my $element_and_group_map = $qti->element_and_group_map;
is( scalar keys %{ $element_and_group_map }, 475, 'element_and_group_map keys mismatch');
isa_ok( $element_and_group_map->{'a'}, 'MyXSD::Element');
is( $element_and_group_map->{'a'}->type, 'a.Type', 'element_and_group_map->{a} type mismatch');
isa_ok( $element_and_group_map->{'a.ContentGroup'}, 'MyXSD::Group');

BEGIN {
    package MyXSD;
    use Moose;
    with 'XML::Rabbit::RootNode';

    has '+namespace_map' => (
        default => sub { {
            'xsd' => 'http://www.w3.org/2001/XMLSchema',
        } }
    );

    has 'element_map' => (
        isa         => 'HashRef[MyXSD::Element]',
        traits      => ['XPathObjectMap'],
        xpath_query => '//xsd:element[@name]',
        xpath_key   => './@name',
    );

    has 'element_and_group_map' => (
        traits      => ['XPathObjectMap'],
        isa_map     => {
            'xsd:element' => 'MyXSD::Element',
            'xsd:group'   => 'MyXSD::Group',
        },
        xpath_query => '//xsd:element[@name]|//xsd:group[@name]',
        xpath_key   => './@name',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package MyXSD::Element;
    use Moose;
    with 'XML::Rabbit::Node';

    has 'type' => (
        traits      => ['XPathValue'],
        xpath_query => './@type',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package MyXSD::Group;
    use Moose;
    with 'XML::Rabbit::Node';

    has 'type' => (
        traits      => ['XPathValue'],
        xpath_query => './@type',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

}

1;
