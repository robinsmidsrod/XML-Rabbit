#!perl -T

use strict;
use warnings;
use Test::Most tests => 1;
lives_ok( sub { use lib 't/lib'; require W3C::XHTML::Body } );
