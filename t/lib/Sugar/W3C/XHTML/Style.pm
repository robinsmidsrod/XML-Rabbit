use strict;
use warnings;

package Sugar::W3C::XHTML::Style;
use XML::Rabbit;

has_xpath_value 'type' => './@type';

__PACKAGE__->meta->make_immutable();

1;
