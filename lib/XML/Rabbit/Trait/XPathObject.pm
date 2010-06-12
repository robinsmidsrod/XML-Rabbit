package XML::Rabbit::Trait::XPathObject;
use Moose::Role;

with 'XML::Rabbit::Trait::XPath';

around '_process_options' => sub {
    my ($orig, $self, $name, $options, @rest) = @_;

    $self->$orig($name, $options, @rest);

    # This should really be:
    # has '+isa' => ( required => 1 );
    # but for some unknown reason Moose doesn't allow that
    confess("isa attribute is required") unless defined( $options->{'isa'} );
};

has 'isa_map' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    default => sub { +{} },
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
sub register_implementation { 'XML::Rabbit::Trait::XPathObject' }

1;

=head1 NAME

XML::Rabbit::Trait::XPathObject - Moose-based XML loader - XML DOM object xpath extractor trait


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    with 'XML::Rabbit::Node';

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

See L<XML::Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<xpath_query>

Inherited from L<XML::Rabbit::Trait::XPath>.


=item C<lazy>

Inherited from L<XML::Rabbit::Trait::XPath>.


=item C<isa>

Indicates that the parent attribute must have its class specified. Read Only.


=item C<default>

Returns a coderef that is run to build the default value of the parent attribute. Read Only.


=item C<meta>

Moose meta object.


=back


=head1 BUGS

See L<XML::Rabbit/BUGS>.


=head1 SUPPORT

See L<XML::Rabbit/SUPPORT>.


=head1 AUTHOR

See L<XML::Rabbit/AUTHOR>.


=head1 COPYRIGHT

See L<XML::Rabbit/COPYRIGHT>.

=head1 LICENSE

See L<XML::Rabbit/LICENSE>.


=cut
