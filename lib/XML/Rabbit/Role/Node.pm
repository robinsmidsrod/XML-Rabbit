use strict;
use warnings;

package XML::Rabbit::Role::Node;
use MooseX::Role::Parameterized;

use Encode ();

# ABSTRACT: Base role for all nodes

=attr node

An instance of a L<XML::LibXML::Node> class representing the a node in an XML document. Read Only.

=cut

parameter 'node'          => ( isa => 'HashRef', default => sub { +{} } );

=attr xpc

An instance of a L<XML::LibXML::XPathContext> class initialized with the C<node> attribute. Read Only.

=cut

parameter 'xpc'           => ( isa => 'HashRef', default => sub { +{} } );

=attr namespace_map

A HashRef of strings that defines the prefix/namespace XML mappings for the
XPath parser. Usually overridden in a subclass like this:

    has '+namespace_map' => (
        default => sub { {
            myprefix      => "http://my.example.com",
            myotherprefix => "http://other.example2.org",
        } },
    );

=cut

parameter 'namespace_map' => ( isa => 'HashRef', default => sub { +{} } );

role {
    my ($p) = @_;

    has '_xpc' => (
        is       => 'ro',
        isa      => 'XML::LibXML::XPathContext',
        reader   => 'xpc',
        init_arg => 'xpc',
        %{ $p->xpc }
    );

    has '_node' => (
        is       => 'ro',
        isa      => 'XML::LibXML::Node',
        reader   => 'node',
        init_arg => 'node',
        %{ $p->node }
    );

    has 'namespace_map' => (
        is       => 'ro',
        isa      => 'HashRef[Str]',
        lazy     => 1,
        default  => sub { +{} },
        %{ $p->namespace_map },
    );

};

=method dump_xml

Dumps the XML of the current node as a native perl string.

=cut

sub dump_xml {
    my ($self) = @_;
    return $self->node->toString(1);
}

no MooseX::Role::Parameterized;

1;

=head1 SYNOPSIS

See L<XML::Rabbit::RootNode> or L<XML::Rabbit::Node> for examples.

=head1 DESCRIPTION

This module provides attributes and methods common to all nodes.

See L<XML::Rabbit> for a more complete example.
