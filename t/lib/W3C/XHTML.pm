use strict;
use warnings;

package W3C::XHTML;
use Moose;
with 'XML::Rabbit::RootNode';

has '+namespace_map' => (
    default => sub { {
        "xhtml" => "http://www.w3.org/1999/xhtml",
    } },
);

has 'title' => (
    isa         => 'Str',
    traits      => [qw(XPathValue)],
    xpath_query => '/xhtml:html/xhtml:head/xhtml:title',
);

has 'style' => (
    isa         => 'Maybe[W3C::XHTML::Style]',
    traits      => [qw(XPathObject)],
    xpath_query => '/xhtml:html/xhtml:head/xhtml:style',
);

has 'body' => (
    isa         => 'W3C::XHTML::Body',
    traits      => [qw(XPathObject)],
    xpath_query => '/xhtml:html/xhtml:body',
);

has 'all_sources' => (
    isa         => 'ArrayRef[Str]',
    traits      => [qw(XPathValueList)],
    xpath_query => '//@src',
);

has 'body_and_all_images' => (
    traits      => ['XPathObjectList'],
    xpath_query => '//xhtml:body|//xhtml:img',
    isa_map     => {
        'xhtml:body' => 'W3C::XHTML::Body',
        'xhtml:img'  => 'W3C::XHTML::Image',
    },
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
