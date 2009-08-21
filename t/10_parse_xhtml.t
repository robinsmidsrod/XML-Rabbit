#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Test::More tests => 7;

my $xhtml = W3C::XHTML->new( file => 't/data/10_parse_xhtml.xhtml' );
isa_ok( $xhtml, 'W3C::XHTML' );
isa_ok( $xhtml->body, 'W3C::XHTML::Body' );
isa_ok( $xhtml->body->images->[0], 'W3C::XHTML::Image' );

is($xhtml->title, 'Hei på deg', 'Main title mismatch' );
is($xhtml->body->images->[0]->src, 'bilde.jpg', 'First image src mismatch');
is($xhtml->body->images->[0]->alt, 'Bilde av forfatter', 'First image alt mismatch');
is($xhtml->body->images->[0]->title, 'Se på mitt bilde', 'First image title mismatch');

exit;

BEGIN {

    package W3C::XHTML;
    use Moose;
    extends 'Rabbit::RootNode';

    has 'namespace_map' => (
        is      => 'ro',
        isa     => 'HashRef[Str]',
        default => sub {
            return { "xhtml" => "http://www.w3.org/1999/xhtml" };
        },
    );

    has 'title' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => '/xhtml:html/xhtml:head/xhtml:title',
    );

    has 'body' => (
        isa         => 'W3C::XHTML::Body',
        traits      => [qw(XPathObject)],
        xpath_query => '/xhtml:html/xhtml:body',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package W3C::XHTML::Body;
    use Moose;
    extends 'Rabbit::Node';

    has 'images' => (
        isa         => 'ArrayRef[W3C::XHTML::Image]',
        traits      => [qw(XPathObjectList)],
        xpath_query => './/xhtml:img',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package W3C::XHTML::Image;
    use Moose;
    extends 'Rabbit::Node';

    has 'src' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@src',
    );

    has 'alt' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@alt',
    );

    has 'title' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

}

1;
