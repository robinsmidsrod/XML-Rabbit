package Rabbit::Document;
use Moose;
extends 'Rabbit::Parser';

use Encode ();

has 'file' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'document' => (
    is         => 'ro',
    isa        => 'XML::LibXML::Document',
    lazy_build => 1,
);

sub _build_document {
    my ( $self ) = @_;
    my $doc = $self->parser->parse_file( $self->file );
    confess("No input file specified.\n") unless $doc;
    return $doc;
}

sub dump {
    my ( $self ) = @_;
    return Encode::decode(
        $self->document->actualEncoding,
        $self->document->toString(1),
    );
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
