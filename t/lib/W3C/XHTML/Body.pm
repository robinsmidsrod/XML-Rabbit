package W3C::XHTML::Body;
use Moose;
with 'Rabbit::Node';

has 'images' => (
    isa         => 'ArrayRef[W3C::XHTML::Image]',
    traits      => [qw(XPathObjectList)],
    xpath_query => './/xhtml:img',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
