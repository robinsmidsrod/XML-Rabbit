package Rabbit::Trait::XPathObjectList;
use Moose::Role;

with 'Rabbit::Trait::XPathObject';

has '+default' => (
    default => sub {
        my ($attr) = @_;
        return sub {
            my ($self) = @_;

            unless ( $self->can('node') ) {
                confess(ref($self) . " has no method 'node'")
            }
            unless ( $self->can('xpc') ) {
                confess(ref($self) . " has no method 'xpc'");
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

            # Get class definition
            my $class = $attr->meta->get_attribute('isa')->get_value($attr);
            $class =~ s/^ArrayRef\[(.*)\]$/$1/;
            Class::MOP::load_class($class);

            my @nodes;
            foreach my $node ( $self->xpc->findnodes( $xpath_query, $self->node ) ) {
                my $instance = $class->new( node => $node, xpc => $self->xpc );
                push @nodes, $instance;
            }
            return \@nodes;

        };
    }
);

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::XPathObjectList;
sub register_implementation { 'Rabbit::Trait::XPathObjectList' }

1;

=head1 NAME

Rabbit::Trait::XPathObjectList - Moose-based XML loader - multiple XML DOM object xpath extractor trait


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    extends 'Rabbit::Node';

    has 'persons' => (
        isa         => 'ArrayRef[MyXMLSyntax::Person]',
        traits      => [qw(XPathObject)],
        xpath_query => './persons/*',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the extraction of multiple complex values (subtrees)
from an XML node based on an XPath query. Each subtree is used as input for
the constructor of the class specified in the isa attribute. All of the
extracted objects are then put into an arrayref which is accessible via the
parent attribute.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<xpath_query>

Inherited from L<Rabbit::Trait::XPath>.


=item C<lazy>

Inherited from L<Rabbit::Trait::XPath>.


=item C<isa>

Inherited from L<Rabbit::Trait::XPathObject>.


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
