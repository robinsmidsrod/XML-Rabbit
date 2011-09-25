use strict;
use warnings;

package XML::Rabbit::Role::Document;
use Moose::Role;

use XML::LibXML 1.69 ();
use Encode ();

# ABSTRACT: XML Document base class

=attr _file

A string representing the path to the file that contains the XML document data. Read Only. Constructor parameter is C<file>.

=cut

has '_file' => (
    is        => 'ro',
    isa       => 'Str',
    init_arg  => 'file',
    predicate => '_has_file',
);

=attr _fh

A glob reference / file handle that points to the XML document data. Read Only. Constructor parameter is C<fh>.

=cut

has '_fh' => (
    is        => 'ro',
    isa       => 'GlobRef',
    init_arg  => 'fh',
    predicate => '_has_fh',
);

=attr _xml

A binary string containing the XML document data. Read Only. Constructor parameter is C<xml>.

=cut

has '_xml' => (
    is        => 'ro',
    isa       => 'Str',
    init_arg  => 'xml',
    predicate => '_has_xml',
);

=attr _document

An instance of an L<XML::LibXML::Document> class. Read Only. Constructor parameter is C<dom>.

=cut

has '_document' => (
    is         => 'ro',
    isa        => 'XML::LibXML::Document',
    lazy_build => 1,
    init_arg   => 'dom',
);

sub _build__document {
    my ( $self ) = @_;
    my $doc;
    # Priority source order is: file, fh, xml (string) if multiple defined
    $doc = $self->_parser->parse_file(   $self->_file ) if $self->_has_file;
    $doc = $self->_parser->parse_fh(     $self->_fh   ) if $self->_has_fh and not defined($doc);
    $doc = $self->_parser->parse_string( $self->_xml  ) if $self->_has_xml and not defined($doc);
    confess("No input specified. Please specify argument file, fh, xml or dom.\n") unless $doc;
    return $doc;
}

has '_parser' => (
    is      => 'ro',
    isa     => 'XML::LibXML',
    lazy    => 1,
    default => sub { XML::LibXML->new(), },
);

=method dump_document_xml

Dumps the XML of the entire document as a native perl string.

=cut

sub dump_document_xml {
    my ( $self ) = @_;
    return Encode::decode(
        $self->_document->actualEncoding,
        $self->_document->toString(1),
    );
}

no Moose::Role;

1;

=head1 SYNOPSIS

    package MyXMLSyntax;
    use Moose;
    with 'XML::Rabbit::Role::Document';

    sub root_node {
        return shift->_document->documentElement();
    }


=head1 DESCRIPTION

This module provides the base document attribute used to hold the parsed XML content.

See L<XML::Rabbit> for a more complete example.
