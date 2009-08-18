package Rabbit::Node;
use Moose;

use Encode ();

has 'node' => (
    is       => 'ro',
    isa      => 'XML::LibXML::Node',
    required => 1,
);

has 'xpc' => (
    is       => 'ro',
    isa      => 'XML::LibXML::XPathContext',
    required => 1,
);

sub dump {
    my ($self) = @_;
    return Encode::decode(
        $self->node->ownerDocument->actualEncoding,
        $self->node->toString(1),
    );
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
