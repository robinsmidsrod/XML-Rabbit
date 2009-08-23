package Rabbit::Role::Node;
use MooseX::Role::Parameterized;

use Encode ();

parameter 'xpc'  => ( isa => 'HashRef', default => sub { +{} } );
parameter 'node' => ( isa => 'HashRef', default => sub { +{} } );

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

};

sub dump_xml {
    my ($self) = @_;
    return Encode::decode(
        $self->node->ownerDocument->actualEncoding,
        $self->node->toString(1),
    );
}

no MooseX::Role::Parameterized;

1;

=head1 NAME

Rabbit::Role::Node - Moose-based XML loader - base role for all nodes


=head1 SYNOPSIS

See L<Rabbit::RootNode> or L<Rabbit::Node> for examples.


=head1 DESCRIPTION

This module provides attributes and methods common to all nodes.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<node>

An instance of a L<XML::LibXML::Node> class representing the a node in an XML document. Read Only.


=item C<xpc>

An instance of a L<XML::LibXML::XPathContext> class initialized with the C<node> attribute. Read Only.


=item C<dump_xml>

Dumps the XML of the current node as a native perl string.


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
