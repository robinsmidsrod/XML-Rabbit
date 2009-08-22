package Rabbit::Node;
use Moose::Role;

with 'Rabbit::Role::Node';

has '+_node' => (
    required => 1,
);

has '+_xpc' => (
    required => 1,
);

no Moose::Role;

1;

=head1 NAME

Rabbit::Node - Moose-based XML loader - node base class


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    with 'Rabbit::Node';

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

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<new>

Standard Moose constructor.


=item C<node>

An instance of a L<XML::LibXML::Node> class representing a node in an XML document tree. Read Only.


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
