#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

BEGIN {
    use lib 't/lib';
    use_ok( 'W3C::XHTML' );
}

# Some content that is not well-formed XML
my $invalid_xml = "abc";
# Some content that is well-formed XML
my $valid_xml_filename = "t/data/10_parse_xhtml.xhtml";

{
    my $xhtml = W3C::XHTML->new( xml => $invalid_xml );
    can_ok( $xhtml, 'validate_document_xml' );
    dies_ok { $xhtml->validate_document_xml() }
        "An invalid XML document should throw a parser exception";
}

{
    my $xhtml = W3C::XHTML->new( file => $valid_xml_filename );
    can_ok( $xhtml, 'validate_document_xml' );
    lives_ok { $xhtml->validate_document_xml() }
        "A valid XML document shouldn't throw a parser exception";
}

exit;

1;
