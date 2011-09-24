package Sugar::W3C::XHTML;
use XML::Rabbit::Root;

add_xpath_namespace "xhtml" => "http://www.w3.org/1999/xhtml";

has_xpath_value 'title' => '/xhtml:html/xhtml:head/xhtml:title';

has_xpath_object 'style' => '/xhtml:html/xhtml:head/xhtml:style' => 'Sugar::W3C::XHTML::Style',
    isa => 'Maybe[Sugar::W3C::XHTML::Style]',
;

has_xpath_object 'body' => '/xhtml:html/xhtml:body' => 'Sugar::W3C::XHTML::Body';

has_xpath_value_list 'all_sources' => '//@src';

has_xpath_object_list 'body_and_all_images' => '//xhtml:body|//xhtml:img',
    {
        'xhtml:body' => 'Sugar::W3C::XHTML::Body',
        'xhtml:img'  => 'Sugar::W3C::XHTML::Image',
    },
;

finalize_class;
