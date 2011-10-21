package Sugar::W3C::XHTML::Body;
use XML::Rabbit;

has_xpath_object_list 'images' => './/xhtml:img' => 'Sugar::W3C::XHTML::Image';

has_xpath_value_map 'h1_text_id_map' => './/xhtml:h1',
    '.' => './@id';

has_xpath_value_map 'h1_id_map' => './/xhtml:h1',
    './@id' => '.';

has_xpath_object_map 'image_map' => './/xhtml:img',
    './@src' => 'Sugar::W3C::XHTML::Image';

has_xpath_object_map 'image_id_map' => './/xhtml:img',
    './@id' => 'Sugar::W3C::XHTML::Image';

finalize_class;
