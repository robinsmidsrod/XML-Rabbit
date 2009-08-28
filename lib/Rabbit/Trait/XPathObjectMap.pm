package Rabbit::Trait::XPathObjectMap;
use Moose::Role;

with 'Rabbit::Trait::XPath';

has '+isa' => (
    required => 1,
);

has 'isa_map' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    default => sub { +{} },
);

has 'xpath_key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has '+default' => (
    builder => '_build_default',
);

sub _build_default {
    my ($self) = @_;
    return sub {
        my ($parent) = @_;
        my $xpath_query = $self->_resolve_xpath_query( $parent );
        $self->_convert_isa_map( $parent );
        my $class = $self->_resolve_class();
        my %node_map;
        foreach my $node ( $self->_find_nodes($parent, $xpath_query ) ) {
            my $key = $parent->xpc->findvalue( $self->xpath_key, $node );
            $node_map{ $key } = $self->_create_instance( $parent, $class, $node );
        }
        return \%node_map;
    };
}

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::XPathObjectMap;
sub register_implementation { 'Rabbit::Trait::XPathObjectMap' }

1;

=head1 NAME

Rabbit::Trait::XPathObjectMap - Moose-based XML loader - multiple XML DOM object xpath extractor trait


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    with 'Rabbit::Node';

    has 'persons' => (
        isa         => 'HashRef[MyXMLSyntax::Person]',
        traits      => [qw(XPathObjectMap)],
        xpath_query => './persons/*',
        xpath_key   => './@name',
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
