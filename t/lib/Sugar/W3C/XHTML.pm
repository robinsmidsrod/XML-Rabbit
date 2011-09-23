package Sugar::W3C::XHTML;
use XML::Rabbit::Root;

has '+namespace_map' => (
    default => sub { {
        "xhtml" => "http://www.w3.org/1999/xhtml",
    } },
);

has_xpath_value 'title' => '/xhtml:html/xhtml:head/xhtml:title';

has_xpath_object 'style',
    'Sugar::W3C::XHTML::Style' => '/xhtml:html/xhtml:head/xhtml:style',
    isa => 'Maybe[Sugar::W3C::XHTML::Style]',
;

has_xpath_object 'body',
    'Sugar::W3C::XHTML::Body' => '/xhtml:html/xhtml:body',
;

has_xpath_value_list 'all_sources' => '//@src';

has_xpath_object_list 'body_and_all_images',
    {
        'xhtml:body' => 'Sugar::W3C::XHTML::Body',
        'xhtml:img'  => 'Sugar::W3C::XHTML::Image',
    },
    '//xhtml:body|//xhtml:img',
;

finalize_class;
