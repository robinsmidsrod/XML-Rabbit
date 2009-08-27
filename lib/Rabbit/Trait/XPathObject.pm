package Rabbit::Trait::XPathObject;
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

has '+default' => (
    builder => '_build_default',
);

sub _build_default {
    my ($self) = @_;
    return sub {
        my ($parent) = @_;
        my $node = $self->_find_node(
            $parent,
            $self->_resolve_xpath_query( $parent ),
        );
        $self->_convert_isa_map( $parent );
        my $class = $self->_resolve_class();
        return $self->_create_instance( $parent, $class, $node );
    };
}

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::XPathObject;
sub register_implementation { 'Rabbit::Trait::XPathObject' }

1;

=head1 NAME

Rabbit::Trait::XPathObject - Moose-based XML loader - XML DOM object xpath extractor trait


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    with 'Rabbit::Node';

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
