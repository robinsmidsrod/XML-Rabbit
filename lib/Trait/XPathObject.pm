package Rabbit::Trait::XPathObject;
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

package Moose::Meta::Attribute::Custom::Trait::XPathObject;
sub register_implementation { 'Rabbit::Trait::XPathObject' }

1;
