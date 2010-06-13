use strict;
use warnings;

package W3C::XMLSchema;
use Moose;
with 'XML::Rabbit::RootNode';

has '+namespace_map' => (
    default => sub { {
        'xsd' => 'http://www.w3.org/2001/XMLSchema',
    } }
);

has 'groups' => (
    isa         => 'ArrayRef[W3C::XMLSchema::Group]',
    traits      => [qw/XPathObjectList/],
    xpath_query => './xsd:group',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
