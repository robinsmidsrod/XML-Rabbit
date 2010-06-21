#!perl -T

use Test::More tests => 7;

BEGIN {
    use_ok( 'XML::Rabbit' );
    use_ok( 'XML::Rabbit::RootNode' );
    use_ok( 'XML::Rabbit::Node' );
    use_ok( 'XML::Rabbit::Trait::XPathValue' );
    use_ok( 'XML::Rabbit::Trait::XPathValueList' );
    use_ok( 'XML::Rabbit::Trait::XPathObject' );
    use_ok( 'XML::Rabbit::Trait::XPathObjectList' );
}

diag( "Testing XML::Rabbit $XML::Rabbit::VERSION, Perl $], $^X" );
