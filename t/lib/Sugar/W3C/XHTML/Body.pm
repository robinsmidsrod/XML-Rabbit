package Sugar::W3C::XHTML::Body;
use XML::Rabbit;

has_xpath_object_list 'images',
    'Sugar::W3C::XHTML::Image' => './/xhtml:img',
;

finalize_class;
