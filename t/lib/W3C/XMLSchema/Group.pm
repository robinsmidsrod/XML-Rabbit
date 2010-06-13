use strict;
use warnings;

package W3C::XMLSchema::Group;
use Moose;
with 'XML::Rabbit::Node';

has 'ref' => (
    traits      => ['XPathValue'],
    xpath_query => './@ref',
);

has 'sequence' => (
    isa         => 'W3C::XMLSchema::Sequence',
    traits      => ['XPathObject'],
    xpath_query => './xsd:sequence',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
