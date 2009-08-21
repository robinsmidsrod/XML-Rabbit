package Rabbit::Trait::XPathObjectList;
use Moose::Role;

has 'xpath_query' => (
    is       => 'ro',
    isa      => 'Str|CodeRef',
    required => 1,
);

has '+is' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'ro',
);

has '+isa' => (
    required => 1,
);

has '+lazy' => (
    default => 1,
);

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
        is          => 'ro',
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

A string or a coderef that generates a string that is the XPath query to use to find the wanted value. Read Only.


=item C<lazy>

Indicates that the parent attribute will be lazy-loaded on first use. Read Only.


=item C<isa>

Indicates that the parent attribute must have its class specified. Read Only.


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
