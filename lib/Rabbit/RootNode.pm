package Rabbit::RootNode;
use Moose;
extends 'Rabbit::Document';

with 'Rabbit::Role::Node';

# Preload XPath attribute traits
use Rabbit::Trait::XPathValue;
use Rabbit::Trait::XPathValueList;
use Rabbit::Trait::XPathObject;
use Rabbit::Trait::XPathObjectList;

has 'namespace_map' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    default => sub { {} },
);

has '+_node' => (
    lazy    => 1,
    default => sub { shift->_document->documentElement(); },
);

has '+_xpc' => (
    lazy    => 1,
    builder => '_build__xpc',
);

sub _build__xpc {
    my ($self) = @_;
    # XML::LibXML loads this class, see Rabbit::Document
    my $xpc = XML::LibXML::XPathContext->new( $self->_document );
    foreach my $prefix ( keys %{ $self->namespace_map } ) {
        $xpc->registerNs($prefix, $self->namespace_map->{$prefix});
    }
    return $xpc;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;

=head1 NAME

Rabbit::RootNode - Moose-based XML loader - root node base class


=head1 SYNOPSIS

    package MyXMLSyntax;
    use Moose;
    extends 'Rabbit::RootNode';

    has title => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => '/root/title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the base node attribute used to hold the root of the XML document.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<new>

Standard Moose constructor.


=item C<namespace_map>

A HashRef of strings that defines the prefix/namespace XML mappings for the
XPath parser. Usually overriden in a subclass like this:

    has '+namespace_map' => (
        default => sub { {
            myprefix      => "http://my.example.com",
            myotherprefix => "http://other.example2.org",
        } },
    );


=item C<node>

An instance of a L<XML::LibXML::Node> class representing the root node of an
XML document. Read Only.

It is lazily loaded from the C<document> attribute, which is inherited from
L<Rabbit::Document>.

=item C<xpc>

An instance of a L<XML::LibXML::XPathContext> class initialized with the
C<node> attribute. Read Only.

If a subclass has an attribute named C<namespace_map> which is a HashRef it
is used to initialize namespaces using the C<registerNs> method. This is
required on XML files that use namespaces, like XHTML.


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
