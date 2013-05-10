#!perl -T

use Test::More tests => 9;

BEGIN {
    require_ok( 'XML::Rabbit' );
    require_ok( 'XML::Rabbit::Sugar' );
    require_ok( 'XML::Rabbit::Root' );
    require_ok( 'XML::Rabbit::RootNode' );
    require_ok( 'XML::Rabbit::Node' );
    require_ok( 'XML::Rabbit::Trait::XPathValue' );
    require_ok( 'XML::Rabbit::Trait::XPathValueList' );
    require_ok( 'XML::Rabbit::Trait::XPathObject' );
    require_ok( 'XML::Rabbit::Trait::XPathObjectList' );
}

diag( "Testing XML::Rabbit $XML::Rabbit::VERSION, Perl $], $^X" );
