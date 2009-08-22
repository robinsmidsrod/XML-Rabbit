package Rabbit::Trait::XPathValueList;
use Moose::Role;

with 'Rabbit::Trait::XPathValue';

has '+isa' => (
    required => 1,
);

has '+default' => (
    default => sub {
        my ($attr) = @_;
        return sub {
            my ($self) = @_;

            # Make sure the parent class implements required role
            unless ( $self->does('Rabbit::Role::Node') ) {
                confess(ref($self) . " doesn't implement Rabbit::Role::Node")
            }

            # Run code reference if necessary to build xpath query
            my $xpath_query = (
                                ref($attr->xpath_query) eq 'CODE'
                             || (
                                  blessed($attr->xpath_query)
                               && $attr->xpath_query->isa('Class::MOP::Method')
                              )
                            )
                            ? $attr->xpath_query->($self)
                            : $attr->xpath_query;

            # Fetch all nodes that match and get value
            my @nodes;
            foreach my $node ( $self->xpc->findnodes( $xpath_query, $self->node ) ) {
                my $value = $node->to_literal;
                push @nodes, ( defined($value) ? $value : "" );
            }
            return \@nodes;
        };
    }
);

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::XPathValueList;
sub register_implementation { 'Rabbit::Trait::XPathValueList' }

1;

=head1 NAME

Rabbit::Trait::XPathValue - Moose-based XML loader - single value xpath extractor trait


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    extends 'Rabbit::Node';

    has title => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the extraction of primitive values from an XML node based on an XPath query.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<xpath_query>

Inherited from L<Rabbit::Trait::XPath>.


=item C<lazy>

Inherited from L<Rabbit::Trait::XPath>.


=item C<default>

Returns a coderef that is run to build the default value of the parent attribute. Read Only.


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
