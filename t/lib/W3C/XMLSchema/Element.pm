use strict;
use warnings;

package W3C::XMLSchema::Element;
use Moose;
with 'XML::Rabbit::Node';

has 'ref' => (
    traits      => [qw/XPathValue/],
    xpath_query => './@ref',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
