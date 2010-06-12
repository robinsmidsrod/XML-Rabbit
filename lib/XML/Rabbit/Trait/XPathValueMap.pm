package XML::Rabbit::Trait::XPathValueMap;
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

has 'xpath_key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'xpath_value' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub _build_default {
    my ($self) = @_;
    return sub {
        my ($parent) = @_;
        my $xpath_query = $self->_resolve_xpath_query( $parent );
        my %node_map;
        foreach my $node ( $self->_find_nodes( $parent, $xpath_query ) ) {
            my $key = $parent->xpc->findvalue( $self->xpath_key, $node );
            my $value = $parent->xpc->findvalue( $self->xpath_value, $node );
            confess("xpath_key value is empty, please revise your xpath_query") unless defined($value) and length $value > 0;
            $node_map{$key} = $value;
        }
        return \%node_map;
    };
}

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::XPathValueMap;
sub register_implementation { 'XML::Rabbit::Trait::XPathValueMap' }

1;

=head1 NAME

XML::Rabbit::Trait::XPathValueMap - Moose-based XML loader - multiple value xpath extractor trait


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    with 'XML::Rabbit::RootNode';

    has reference_map => (
        isa         => 'HashRef[Str]',
        traits      => [qw(XPathValueMap)],
        xpath_query => '//*[@href]',
        xpath_key   => './@href',
        xpath_value => './@title';
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the extraction of primitive values from an XML node based on an XPath query.

See L<XML::Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<xpath_query>

Inherited from L<XML::Rabbit::Trait::XPath>.


=item C<lazy>

Inherited from L<XML::Rabbit::Trait::XPath>.


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
