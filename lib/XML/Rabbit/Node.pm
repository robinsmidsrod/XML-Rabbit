use strict;
use warnings;

package XML::Rabbit::Node;
use Moose::Role 1.05;

# ABSTRACT: Node base class

=attr node

An instance of a L<XML::LibXML::Node> class representing a node in an XML document tree. Read Only.

=attr xpc

An instance of a L<XML::LibXML::XPathContext> class initialized with the C<node> attribute. Read Only.

=cut

with 'XML::Rabbit::Role::Node' => {
    'node'          => { required => 1 },
    'xpc'           => { required => 1 },
    'namespace_map' => { required => 1 },
};

no Moose::Role;

1;

=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    with 'XML::Rabbit::Node';

    has title => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the base node attribute used to hold a specific node in the XML docuent tree.

See L<XML::Rabbit> for a more complete example.
