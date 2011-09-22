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
    use XML::Rabbit::Root;

    has '+namespace_map' => (
        default => sub { {
            'xsd' => 'http://www.w3.org/2001/XMLSchema',
        } }
    );

    has_xpath_object_map 'element_map',
        'MyXSD::Element' => '//xsd:element[@name]',
        './@name',
    ;

    has_xpath_object_map 'element_and_group_map',
        {
            'xsd:element' => 'MyXSD::Element',
            'xsd:group'   => 'MyXSD::Group',
        },
        '//xsd:element[@name]|//xsd:group[@name]' => './@name',
    ;

    __PACKAGE__->meta->make_immutable();

    package MyXSD::Element;
    use XML::Rabbit;

    has_xpath_value 'type' => './@type';

    __PACKAGE__->meta->make_immutable();

    package MyXSD::Group;
    use XML::Rabbit;

    has_xpath_value 'type' => './@type';

    __PACKAGE__->meta->make_immutable();

}

1;
