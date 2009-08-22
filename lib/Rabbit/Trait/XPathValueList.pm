package Rabbit::Trait::XPathValueList;
use Moose::Role;

with 'Rabbit::Trait::XPath';

has '+isa' => (
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
        my @nodes;
        foreach my $node ( $self->_find_nodes( $parent, $xpath_query ) ) {
            push @nodes, $node->to_literal . "";
        }
        return \@nodes;
    };
}

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::XPathValueList;
sub register_implementation { 'Rabbit::Trait::XPathValueList' }

1;

=head1 NAME

Rabbit::Trait::XPathValueList - Moose-based XML loader - multiple value xpath extractor trait


=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    extends 'Rabbit::RootNode';

    has all_references => (
        isa         => 'ArrayRef[Str]',
        traits      => [qw(XPathValueList)],
        xpath_query => '//@href|//@src',
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
