package Rabbit::Trait::XPathObjectList;
use Moose::Role;

has 'xpath_query' => (
    is       => 'ro',
    isa      => 'Str|CodeRef',
    required => 1,
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
