#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Test::More tests => 15;
use Test::Exception;

BEGIN {
    use lib 't/lib';
    use_ok( 'Sugar::W3C::XHTML' );
}

my $xhtml = Sugar::W3C::XHTML->new( file => 't/data/10_parse_xhtml.xhtml' );
my $body = $xhtml->body;

# RT #71815: keys on value_map is required, but value is optional
can_ok( $body, 'h1_text_id_map');
lives_ok { $body->h1_text_id_map } 'h1_text_id_map should not throw exception';
my $h1_text_id_map = $body->h1_text_id_map;
is( keys %$h1_text_id_map, 1, "h1_text_id_map should have 1 key" );
is( $h1_text_id_map->{ (keys %$h1_text_id_map)[0] }, '', 'Non-present element/attribute should become empty string' );

# Key values on object_map are also required
can_ok( $body, 'image_map' );
lives_ok { $body->image_map } 'image_map should not throw exception';
my $image_map = $body->image_map;
is( keys %$image_map, 1, 'image_map should have 1 key' );
isa_ok( $image_map->{'bilde.jpg'}, 'Sugar::W3C::XHTML::Image' );

# Elements without matching xpath_key query should be skipped, not die
can_ok( $body, 'h1_id_map' );
lives_ok { $body->h1_id_map } 'h1_id_map should not throw exception';
is( keys %{ $body->h1_id_map }, 0, "h1_id_map should have no elements");

# Elements without matching xpath_key query should be skipped, not die (this for objects)
can_ok( $body, 'image_id_map' );
lives_ok { $body->image_id_map } 'image_id_map should not throw exception';
is( keys %{ $body->image_id_map }, 0, "image_id_map should have no elements");

exit;

1;
