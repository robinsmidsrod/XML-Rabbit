package Rabbit::Trait::XPath;
use Moose::Role;
use Moose::Util::TypeConstraints;

around '_process_options' => sub {
    my ($orig, $self, $name, $options, @rest) = @_;

    # This should really be:
    # has '+is' => ( is => 'ro', default => 'ro' );
    # but for some unknown reason Moose doesn't allow that
    $options->{'is'} = 'ro' unless exists $options->{'is'};

    # Specifying node_map builds 'isa' for you
    unless ( exists $options->{'isa'} ) {
        if ( $options->{'node_map'} ) {
            my @classes;
            foreach my $value ( values %{ $options->{'node_map'} } ) {
                class_type($value);
                push @classes, $value,
            }
            $options->{'isa'} = 'ArrayRef[' . join('|',@classes) . ']';
        }
    }

    $self->$orig($name, $options, @rest);
};

has 'xpath_query' => (
    is       => 'ro',
    isa      => 'Str|CodeRef',
    required => 1,
);

has '+lazy' => (
    default => 1,
);

sub _verify_parent_role {
    my ($self, $parent) = @_;

    # Make sure the parent class implements required role
    unless ( $parent->does('Rabbit::Role::Node') ) {
        confess( ref($parent) . " doesn't implement Rabbit::Role::Node");
    }

    return 1;
}

sub _resolve_xpath_query {
    my ($self, $parent) = @_;

    # Figure out if xpath_query is code
    my $query_is_object = blessed($self->xpath_query) ? 1 : 0;
    my $query_is_coderef = ref($self->xpath_query) eq 'CODE' ? 1 : 0;
    my $query_is_code = $query_is_coderef;
       $query_is_code ||= $query_is_object && $self->xpath_query->isa('Class::MOP::Method');

    # Run code reference if necessary to build xpath query.
    # The parent object is the first param to the coderef, not the attribute.
    # This allows the resolution of information in the coderef to happen
    # from the perspective of the class that uses the attribute instead from
    # the perspective of the attribute.
    # Finally overwrite coderef with static value.
    my $xpath_query = $query_is_code ? $self->xpath_query->($parent) : $self->xpath_query;

    return $xpath_query;
}

sub _resolve_class {
    my ($self) = @_;

    # Get class definition
    my $class = $self->meta->get_attribute('isa')->get_value($self);

    # Get ArrayRef[*] - this is probably not the proper way to do this
    $class =~ s/^ArrayRef\[(.*)\]$/$1/;

    # If $class is a union, return a class map instead
    if ( $class =~ /\|/ ) {
        my $class_map = {};
        foreach my $class_name ( split(/\|/, $class) ) {
            $class_map->{$class_name} = 1;
            Class::MOP::load_class($class_name);
        }
        return $class_map;
    }

    # Runtime load it
    Class::MOP::load_class($class);

    return $class;
}

sub _create_instance {
    my ($self, $parent, $class, $node) = @_;
    if ( ref($class) eq 'HASH' ) {
        #my $ns_uri = $node->namespaceURI();
        #my $prefix = $node->lookupNamespacePrefix( $ns_uri );
        #warn "prefix: $prefix\n";
        #warn "namespaces: " . join(",", $node->getNamespaces) . "\n";
        my $node_name = ( $node->prefix ? $node->prefix . ':' : "" ) . $node->localname;
        $class = $self->node_map->{ $node_name };
    }
    confess("Unable to resolve class for node " . $node->nodeName) unless $class;
    my $instance = $class->new( xpc => $parent->xpc, node => $node );
    return $instance;
}

sub _find_node {
    my ($self, $parent, $xpath_query) = @_;
    $self->_verify_parent_role( $parent );
    my $node = $parent->xpc->find( $xpath_query, $parent->node );
    $node = XML::LibXML::Element->new() unless blessed($node);
    $node = $node->shift if $node->isa('XML::LibXML::NodeList'); # Get first item if multiple results
    return $node;
}

sub _find_nodes {
    my ($self, $parent, $xpath_query) = @_;
    $self->_verify_parent_role( $parent );
    my @nodes;
    foreach my $node ( $parent->xpc->findnodes( $xpath_query, $parent->node ) ) {
        push @nodes, $node if blessed($node);
    }
    return wantarray ? @nodes : \@nodes;
}

no Moose::Role;
no Moose::Util::TypeConstraints;

1;

=head1 NAME

Rabbit::Trait::XPath - Moose-based XML loader - base role for other xpath traits


=head1 SYNOPSIS

    package Rabbit::Trait::XPathSomething;
    use Moose::Role;
    with 'Rabbit::Trait::XPath';

    1;

=head1 DESCRIPTION

This module provides base methods for other xpath traits.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<xpath_query>

A string or a coderef that generates a string that is the XPath query to use to find the wanted value. Read Only.


=item C<lazy>

Indicates that the parent attribute will be lazy-loaded on first use. Read Only.


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
