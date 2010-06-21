#/usr/bin/env perl

use strict;
use warnings;

use XML::LibXML;

use Test::More tests => 1;

my $v = XML::LibXML::LIBXML_RUNTIME_VERSION();

diag("Detected libxml2 version: $v");

if ( $v == 20616 ) {
    BAIL_OUT("Incompatible libxml2 version 2.6.16 detected!");
};

isnt($v, 20616, 'libxml2 is not 2.6.16');
