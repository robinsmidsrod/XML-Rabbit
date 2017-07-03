#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;
use Test::Exception;

use lib 't/lib';

lives_ok(
    sub { require W3C::XHTML::Body },
    "XML::Rabbit::Node subclass can be loaded without XML::Rabbit::RootNode loaded",
);
