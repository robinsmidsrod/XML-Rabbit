use strict;
use warnings;

package XML::Rabbit::Sugar;

# ABSTRACT: Sugar functions for easier declaration of xpath attributes

use Scalar::Util qw(blessed);
use Carp qw(confess);

use Moose (); # no magic, just load
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    with_meta => [qw(
        finalize_class
        add_xpath_namespace
        has_xpath_value
        has_xpath_value_list
        has_xpath_value_map
        has_xpath_object
        has_xpath_object_list
        has_xpath_object_map
    )],
    also => 'Moose',
);

=func add_xpath_namespace($namespace, $url)

Adds the XPath namespace with its associated url to the namespace_map hash

=cut

sub add_xpath_namespace {
    my ($meta, $namespace, $url) = @_;
    my $attr = $meta->find_attribute_by_name('namespace_map');
    confess("namespace_map attribute not present") unless blessed($attr);
    my $default = $attr->default;
    my $new_default = sub { my $hash = $default->(@_); $hash->{$namespace} = $url; return $hash; };
    my $new_attr = $attr->clone_and_inherit_options(default => $new_default);
    $meta->add_attribute($new_attr);
    return 1;
}

=func finalize_class()

Convenience function that calls __PACKAGE__->meta->make_immutable() for you

=cut

sub finalize_class {
    my ($meta) = @_;
    $meta->make_immutable();
    return 1; # so we can avoid the 1; at the end of the file
}

=func has_xpath_value($attr_name, $xpath_query, @moose_params)

    # isa automatically set to 'Str'
    # native trait automatically set to 'String'
    has_xpath_value 'name' => './name',
        ...
    ;

=cut

sub has_xpath_value {
    my ($meta, $attr_name, $xpath_query, @moose_params) = @_;
    $meta->add_attribute($attr_name,
        is          => 'ro',
        isa         => 'Str',
        traits      => [qw( XPathValue String )],
        xpath_query => $xpath_query,
        default     => '',
        @moose_params,
    );
    return 1;
}

=func has_xpath_value_list($attr_name, $xpath_query, @moose_params)

    # isa automatically set to 'ArrayRef[Str]'
    # native trait automatically set to 'Array'
    has_xpath_value_list 'streets' => './street',
        ...
    ;

=cut

sub has_xpath_value_list {
    my ($meta, $attr_name, $xpath_query, @moose_params) = @_;
    $meta->add_attribute($attr_name,
        isa         => 'ArrayRef[Str]',
        traits      => [qw( XPathValueList Array )],
        xpath_query => $xpath_query,
        default     => sub { [] },
        @moose_params,
    );
    return 1;
}

=func has_xpath_value_map($attr_name, $xpath_query, $xpath_key, $xpath_value, @moose_params)

    # isa automatically set to 'HashRef[Str]'
    # native trait automatically set to 'Hash'
    has_xpath_value_map 'employee_map' => './employees/*',
        './@ssn' => './name',
        ...
    ;

=cut

sub has_xpath_value_map {
    my ($meta, $attr_name, $xpath_query, $xpath_key, $xpath_value, @moose_params) = @_;
    $meta->add_attribute($attr_name,
        isa         => 'HashRef[Str]',
        traits      => [qw( XPathValueMap Hash )],
        xpath_query => $xpath_query,
        xpath_key   => $xpath_key,
        xpath_value => $xpath_value,
        default     => sub { +{} },
        @moose_params,
    );
    return 1;
}

=func has_xpath_object($attr_name, $isa, $xpath_query, @moose_params)

    # isa automatically set to 'My::Department'
    has_xpath_object 'department',
        'My::Department' => './department',
        ...
    ;

=cut

=func has_xpath_object($attr_name, $isa_map, $xpath_query, @moose_params)

    # isa automatically set to 'My::Department|My::Team'
    has_xpath_object 'department',
        {
            'department' => 'My::Department',
            'team'       => 'My::Team',
        }
        './department|./team',
        ...
    ;

=cut

sub has_xpath_object {
    my ($meta, $attr_name, $isa, $xpath_query, @moose_params) = @_;
    my @isa = ref($isa) eq 'HASH'
            ? ( isa_map => $isa )
            : ( isa     => $isa )
    ;
    $meta->add_attribute($attr_name, @isa,
        traits      => [qw( XPathObject )],
        xpath_query => $xpath_query,
        @moose_params,
    );
    return 1;
}

=func has_xpath_object_list($attr_name, $isa, $xpath_query, @moose_params)

    # isa automatically set to 'ArrayRef[My::Customer]'
    # native trait automatically set to 'Array'
    has_xpath_object_list 'customers',
        'My::Customer' => './customer',
        ...
    ;

=cut

=func has_xpath_object_list($attr_name, $isa_map, $xpath_query, @moose_params)

    # isa automatically set to 'ArrayRef[My::Customer|My::Partner]'
    # native trait automatically set to 'Array'
    has_xpath_object_list 'externals',
        {
            'customer' => 'My::Customer',
            'partner'  => 'My::Partner',
        },
        './customer|./partner',
        ...
    ;

=cut

sub has_xpath_object_list {
    my ($meta, $attr_name, $isa, $xpath_query, @moose_params) = @_;
    my @isa = ref($isa) eq 'HASH'
            ? ( isa_map => $isa )
            : ( isa     => 'ArrayRef[' . $isa . ']' )
    ;
    $meta->add_attribute($attr_name, @isa,
        traits      => [qw( XPathObjectList Array )],
        xpath_query => $xpath_query,
        default     => sub { +[] },
        @moose_params,
    );
    return 1;
}

=func has_xpath_object_map($attr_name, $isa, $xpath_query, $xpath_key, @moose_params)

    # isa automatically set to 'HashRef[My::Product]'
    # native trait automatically set to 'Hash'
    has_xpath_object_map 'product_map' => 'My::Product',
        './products/*' => './@code',
        ...
    ;

=cut

=func has_xpath_object_map($attr_name, $isa_map, $xpath_query, $xpath_key, @moose_params)

    # isa automatically set to 'HashRef[My::Product|My::My::Service]'
    # native trait automatically set to 'Hash'
    has_xpath_object_map 'merchandise_map',
            {
            'service' => 'My::Service',
            'product' => 'My::Product',
            }
        './products/*|./services/*' => './@code',
        ...
    ;

=cut

sub has_xpath_object_map {
    my ($meta, $attr_name, $isa, $xpath_query, $xpath_key, @moose_params) = @_;
    my @isa = ref($isa) eq 'HASH'
            ? ( isa_map => $isa )
            : ( isa     => 'HashRef[' . $isa . ']' )
    ;
    $meta->add_attribute($attr_name, @isa,
        traits      => [qw( XPathObjectMap Hash )],
        xpath_query => $xpath_query,
        xpath_key   => $xpath_key,
        default     => sub { +{} },
        @moose_params,
    );
    return 1;
}

no Moose::Exporter;

1;
