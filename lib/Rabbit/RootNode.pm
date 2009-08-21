package Rabbit::RootNode;
use Moose;
extends 'Rabbit::Document';

use XML::LibXML::XPathContext ();

# Preload XPath attribute traits
use Rabbit::Trait::XPathValue;
use Rabbit::Trait::XPathObject;
use Rabbit::Trait::XPathObjectList;

has '_xpc' => (
    is         => 'ro',
    isa        => 'XML::LibXML::XPathContext',
    lazy_build => 1,
    reader     => 'xpc',
);

sub _build__xpc {
    my ($self) = @_;
    my $xpc = XML::LibXML::XPathContext->new( $self->document );
    if ( $self->can('namespace_map') ) {
        foreach my $prefix ( keys %{ $self->namespace_map } ) {
            $xpc->registerNs($prefix, $self->namespace_map->{$prefix});
        }
    }
    return $xpc;
}

has '_node' => (
    is         => 'ro',
    isa        => 'XML::LibXML::Node',
    lazy_build => 1,
    reader     => 'node',
);

sub _build__node {
    my ($self) = @_;
    return $self->document->documentElement();
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
        is          => 'ro',
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


=item C<node>

An instance of a L<XML::LibXML::Node> class representing the root node of an XML document. Read Only.


=item C<xpc>

An instance of a L<XML::LibXML::XPathContext> class initialized with the C<node> attribute. Read Only.


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
