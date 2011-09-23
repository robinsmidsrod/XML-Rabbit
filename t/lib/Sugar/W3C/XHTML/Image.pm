package Sugar::W3C::XHTML::Image;
use XML::Rabbit;

has_xpath_value 'src'   => './@src';
has_xpath_value 'alt'   => './@alt';
has_xpath_value 'title' => './@title';

finalize_class;
