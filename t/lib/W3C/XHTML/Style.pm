use strict;
use warnings;

package W3C::XHTML::Style;
use Moose;
with 'XML::Rabbit::Node';

has 'type' => (
    isa         => 'Str',
    traits      => [qw(XPathValue)],
    xpath_query => './@type',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
