#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Rabbit' );
}

diag( "Testing Rabbit $Rabbit::VERSION, Perl $], $^X" );
