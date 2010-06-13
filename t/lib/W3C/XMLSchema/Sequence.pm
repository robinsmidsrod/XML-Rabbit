use strict;
use warnings;

package W3C::XMLSchema::Sequence;
use Moose;
with 'XML::Rabbit::Node';

has 'items' => (
    traits      => ['XPathObjectList'],
    xpath_query => './*',
    isa_map     => {
        'xsd:group'   => 'W3C::XMLSchema::Group',
        'xsd:element' => 'W3C::XMLSchema::Element',
    },
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
