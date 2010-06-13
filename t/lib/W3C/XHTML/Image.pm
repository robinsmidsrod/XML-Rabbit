use strict;
use warnings;

package W3C::XHTML::Image;
use Moose;
with 'XML::Rabbit::Node';

has 'src' => (
    isa         => 'Str',
    traits      => [qw(XPathValue)],
    xpath_query => './@src',
);

has 'alt' => (
    isa         => 'Str',
    traits      => [qw(XPathValue)],
    xpath_query => './@alt',
);

has 'title' => (
    isa         => 'Str',
    traits      => [qw(XPathValue)],
    xpath_query => './@title',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
