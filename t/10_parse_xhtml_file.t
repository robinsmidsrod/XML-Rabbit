#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Test::More tests => 24;

BEGIN {
    use lib 't/lib';
    use_ok( 'W3C::XHTML' );
}

my $xhtml = W3C::XHTML->new( file => 't/data/10_parse_xhtml.xhtml' );
isa_ok( $xhtml, 'W3C::XHTML' );
can_ok( $xhtml, 'xpc' ); # XPathContext should be available
isa_ok( $xhtml->xpc, 'XML::LibXML::XPathContext');

can_ok( $xhtml, 'title');
is($xhtml->title, 'Hei på deg', 'Main title mismatch' );

can_ok( $xhtml, 'style');
is( $xhtml->style, undef, 'Style tag mismatch' );

can_ok( $xhtml, 'body');
my $body = $xhtml->body;
isa_ok( $body, 'W3C::XHTML::Body' );

can_ok( $body, 'images' );
my $images = $body->images;
ok(ref($images) eq 'ARRAY', 'images array is not an array');

is( @$images, 1, 'Image list count mismatch');
my $img1 = $images->[0];
isa_ok( $img1, 'W3C::XHTML::Image' );

is($img1->src, 'bilde.jpg', 'First image src mismatch');
is($img1->alt, 'Bilde av forfatter', 'First image alt mismatch');
is($img1->title, 'Se på mitt bilde', 'First image title mismatch');

can_ok( $xhtml, 'all_sources' );
my $sources = $xhtml->all_sources;
is( @$sources, 1, 'All_sources list count mismatch');
is( $sources->[0], 'bilde.jpg', 'First src mismatch');

can_ok( $xhtml, 'body_and_all_images' );
is( scalar @{ $xhtml->body_and_all_images }, 2, 'body_and_all_images count mismatch');
isa_ok($xhtml->body_and_all_images->[0], 'W3C::XHTML::Body');
isa_ok($xhtml->body_and_all_images->[1], 'W3C::XHTML::Image');

exit;

1;
