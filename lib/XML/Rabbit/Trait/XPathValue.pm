use strict;
use warnings;

package XML::Rabbit::Trait::XPathValue;
use Moose::Role 1.05;

with 'XML::Rabbit::Trait::XPath';

# ABSTRACT: Single value xpath extractor trait

=method _build_default

Returns a coderef that is run to build the default value of the parent attribute. Read Only.

=cut

sub _build_default {
    my ($self) = @_;
    return sub {
        my ($parent) = @_;
        my $node = $self->_find_node(
            $parent,
            $self->_resolve_xpath_query( $parent ),
        );
        return blessed($node) ? $node->to_literal . "" : "";
    };
}

no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::XPathValue;
sub register_implementation { return 'XML::Rabbit::Trait::XPathValue' }

1;

=head1 SYNOPSIS

    package MyXMLSyntaxNode;
    use Moose;
    with 'XML::Rabbit::Node';

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

See L<XML::Rabbit> for a more complete example.
