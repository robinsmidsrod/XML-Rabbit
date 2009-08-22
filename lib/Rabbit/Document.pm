package Rabbit::Document;
use Moose;

use XML::LibXML 1.69 ();
use Encode ();

has '_file' => (
    is        => 'ro',
    isa       => 'Str',
    init_arg  => 'file',
    predicate => '_has_file',
);

has '_fh' => (
    is        => 'ro',
    isa       => 'GlobRef',
    init_arg  => 'fh',
    predicate => '_has_fh',
);

has '_xml' => (
    is        => 'ro',
    isa       => 'Str',
    init_arg  => 'xml',
    predicate => '_has_xml',
);

has '_parser' => (
    is      => 'ro',
    isa     => 'XML::LibXML',
    lazy    => 1,
    default => sub { XML::LibXML->new(), },
);

has '_document' => (
    is       => 'ro',
    isa      => 'XML::LibXML::Document',
    lazy     => 1,
    builder  => '_build__document',
    reader   => '_document',
    init_arg => 'dom',
);

sub _build__document {
    my ( $self ) = @_;
    my $doc;
    # Priority source order is: file, fh, xml (string) if multiple defined
    $doc = $self->_parser->parse_file(   $self->_file ) if $self->_has_file;
    $doc = $self->_parser->parse_fh(     $self->_fh   ) if $self->_has_fh and not defined($doc);
    $doc = $self->_parser->parse_string( $self->_xml  ) if $self->_has_xml and not defined($doc);
    confess("No input specified. Please specify argument file, fh or xml.\n") unless $doc;
    return $doc;
}

sub dump_document_xml {
    my ( $self ) = @_;
    return Encode::decode(
        $self->_document->actualEncoding,
        $self->_document->toString(1),
    );
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;

=head1 NAME

Rabbit::Document - Moose-based XML loader - document base class


=head1 SYNOPSIS

    package MyXMLSyntax;
    use Moose;
    extends 'Rabbit::Document';

    sub root_node {
        return shift->_document->documentElement();
    }


=head1 DESCRIPTION

This module provides the base document attribute used to hold the parsed XML content.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<new>

Standard Moose constructor.


=item C<file>

A string representing the path to the file that contains the XML document data. Required.


=item C<_document>

An instance of a L<XML::LibXML::Document> class. Read Only.


=item C<dump_document_xml>

Dumps the XML of the entire document as a native perl string.


=item C<meta>

Moose meta object.


=back


=head1 BUGS

See L<Rabbit/BUGS>.


=head1 SUPPORT

See L<Rabbit/SUPPORT>.


=head1 AUTHOR

See L<Rabbit/AUTHOR>.


=head1 COPYRIGHT

See L<Rabbit/COPYRIGHT>.

=head1 LICENSE

See L<Rabbit/LICENSE>.


=cut
