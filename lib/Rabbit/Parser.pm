package Rabbit::Parser;
use Moose;

use XML::LibXML ();

has 'parser' => (
    is         => 'ro',
    isa        => 'XML::LibXML',
    lazy_build => 1,
);

sub _build_parser {
    my ($self) = @_;
    return XML::LibXML->new();
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
