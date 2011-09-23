#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Test::More tests => 27;

BEGIN {
    use lib 't/lib';
    use_ok( 'Sugar::W3C::XHTML' );
}

my $xhtml = Sugar::W3C::XHTML->new( file => 't/data/10_parse_xhtml.xhtml' );
isa_ok( $xhtml, 'Sugar::W3C::XHTML' );
ok( $xhtml->meta->is_immutable, "Sugar::W3C::XHTML is immutable" );
can_ok( $xhtml, 'xpc' ); # XPathContext should be available
isa_ok( $xhtml->xpc, 'XML::LibXML::XPathContext');

can_ok( $xhtml, 'title');
is($xhtml->title, 'Hei på deg', 'Main title mismatch' );

can_ok( $xhtml, 'style');
is( $xhtml->style, undef, 'Style tag mismatch' );

can_ok( $xhtml, 'body');
my $body = $xhtml->body;
isa_ok( $body, 'Sugar::W3C::XHTML::Body' );
ok( $body->meta->is_immutable, "Sugar::W3C::XHTML::Body is immutable" );

can_ok( $body, 'images' );
my $images = $body->images;
ok(ref($images) eq 'ARRAY', 'images array is not an array');

is( @$images, 1, 'Image list count mismatch');
my $img1 = $images->[0];
isa_ok( $img1, 'Sugar::W3C::XHTML::Image' );
ok( $img1->meta->is_immutable, "Sugar::W3C::XHTML::Image is immutable" );

is($img1->src, 'bilde.jpg', 'First image src mismatch');
is($img1->alt, 'Bilde av forfatter', 'First image alt mismatch');
is($img1->title, 'Se på mitt bilde', 'First image title mismatch');

can_ok( $xhtml, 'all_sources' );
my $sources = $xhtml->all_sources;
is( @$sources, 1, 'All_sources list count mismatch');
is( $sources->[0], 'bilde.jpg', 'First src mismatch');

can_ok( $xhtml, 'body_and_all_images' );
is( scalar @{ $xhtml->body_and_all_images }, 2, 'body_and_all_images count mismatch');
isa_ok($xhtml->body_and_all_images->[0], 'Sugar::W3C::XHTML::Body');
isa_ok($xhtml->body_and_all_images->[1], 'Sugar::W3C::XHTML::Image');

exit;

1;
