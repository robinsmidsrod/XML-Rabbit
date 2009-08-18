package Rabbit::Trait::XPathValue;
use Moose::Role;

has 'xpath_query' => (
    is       => 'ro',
    isa      => 'Str|CodeRef',
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

            my $value = $self->xpc->findvalue( $xpath_query, $self->node );
            return defined($value) ? $value : "";
        };
    }
);

package Moose::Meta::Attribute::Custom::Trait::XPathValue;
sub register_implementation { 'Rabbit::Trait::XPathValue' }

1;
