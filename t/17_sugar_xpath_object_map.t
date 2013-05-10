#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 13;

my $qti = MyXSD->new( file => 't/data/imsqti_v2p1.xsd' );
ok( $qti->meta->is_immutable, "MyXSD is immutable" );
ok( ! $qti->can('add_xpath_namespace'), "MyXSD doesn't re-export internal imports" );

can_ok($qti, 'element_map');
my $element_map = $qti->element_map;
is( scalar keys %{ $element_map }, 254, 'element_map keys mismatch');
is( $element_map->{'a'}->type, 'a.Type', 'element_map->{a} type mismatch');

can_ok($qti, 'element_and_group_map');
my $element_and_group_map = $qti->element_and_group_map;
is( scalar keys %{ $element_and_group_map }, 475, 'element_and_group_map keys mismatch');
isa_ok( $element_and_group_map->{'a'}, 'MyXSD::Element');
ok( $element_and_group_map->{'a'}->meta->is_immutable, "MyXSD::Element is immutable" );
is( $element_and_group_map->{'a'}->type, 'a.Type', 'element_and_group_map->{a} type mismatch');
isa_ok( $element_and_group_map->{'a.ContentGroup'}, 'MyXSD::Group');
ok( $element_and_group_map->{'a.ContentGroup'}->meta->is_immutable, "MyXSD::Group is immutable" );
ok( ! $element_and_group_map->{'a.ContentGroup'}->can('add_xpath_namespace'), "MyXSD::Group doesn't re-export internal imports" );

BEGIN {
    package MyXSD;
    use XML::Rabbit::Root;

    add_xpath_namespace 'xsd' => 'http://www.w3.org/2001/XMLSchema';

    has_xpath_object_map 'element_map' => '//xsd:element[@name]',
        './@name' => 'MyXSD::Element';

    has_xpath_object_map 'element_and_group_map' => '//xsd:element[@name]|//xsd:group[@name]',
        './@name' => {
                         'xsd:element' => 'MyXSD::Element',
                         'xsd:group'   => 'MyXSD::Group',
                     },
    ;

    finalize_class;

    package MyXSD::Element;
    use XML::Rabbit;

    has_xpath_value 'type' => './@type';

    finalize_class;

    package MyXSD::Group;
    use XML::Rabbit;

    has_xpath_value 'type' => './@type';

    finalize_class;
}

1;
