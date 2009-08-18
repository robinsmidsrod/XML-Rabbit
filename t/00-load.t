#!perl -T

use Test::More tests => 6;

BEGIN {
	use_ok( 'Rabbit' );
    use_ok( 'Rabbit::RootNode' );
    use_ok( 'Rabbit::Node' );
    use_ok( 'Rabbit::Trait::XPathValue' );
    use_ok( 'Rabbit::Trait::XPathObject' );
    use_ok( 'Rabbit::Trait::XPathObjectList' );
}

diag( "Testing Rabbit $Rabbit::VERSION, Perl $], $^X" );
