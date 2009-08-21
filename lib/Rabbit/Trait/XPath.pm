package Rabbit::Trait::XPath;
use Moose::Role;

around '_process_options' => sub {
    my ($orig, $self, $name, $options, @rest) = @_;
    $options->{'is'} = 'ro' unless exists $options->{'is'};
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
