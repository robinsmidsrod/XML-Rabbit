package Sugar::W3C::XHTML::Body;
use XML::Rabbit;

has_xpath_object_list 'images' => './/xhtml:img' => 'Sugar::W3C::XHTML::Image';

finalize_class;
