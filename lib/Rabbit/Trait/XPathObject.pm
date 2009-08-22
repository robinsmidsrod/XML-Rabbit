package Rabbit::Trait::XPathObject;
use Moose::Role;

with 'Rabbit::Trait::XPath';

has '+isa' => (
    required => 1,
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

            # Do the search
            my $node = $self->xpc->find( $xpath_query, $self->node );
            unless ( blessed($node) ) {
                confess("XPath query '$xpath_query' didn't return a result");
            }

            # Get first item of the list
            if ( $node->isa('XML::LibXML::NodeList') ) {
                $node = $node->shift();
            }

            my $class = $attr->meta->get_attribute('isa')->get_value($attr);
            Class::MOP::load_class($class);

            my $instance = $class->new( xpc => $self->xpc, node => $node );
            return $instance;
        };
    }
);

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::XPathObject;
sub register_implementation { 'Rabbit::Trait::XPathObject' }

1;

=head1 NAME

Rabbit::Trait::XPathObject - Moose-based XML loader - XML DOM object xpath extractor trait


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    extends 'Rabbit::Node';

    has 'first_person' => (
        isa         => 'MyXMLSyntax::Person',
        traits      => [qw(XPathObject)],
        xpath_query => './person[1]',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the extraction of complex values (subtrees) from an XML
node based on an XPath query. The subtree is used as input for the
constructor of the class specified in the isa attribute.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<xpath_query>

Inherited from L<Rabbit::Trait::XPath>.


=item C<lazy>

Inherited from L<Rabbit::Trait::XPath>.


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
