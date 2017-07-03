#!perl

use strict;
use warnings;
use utf8;

use Test::More tests => 1;

BEGIN {
    use lib 't/lib';
    use W3C::XHTML;
}

my $xhtml = W3C::XHTML->new( file => 't/data/10_parse_xhtml.xhtml' );

my $body = $xhtml->body;
my $images = $body->images;
ok(ref($images) eq 'ARRAY', 'images array is not an array');

exit;

1;
