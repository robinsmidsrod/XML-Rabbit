use strict;
use warnings;

package Sugar::W3C::XMLSchema::Element;
use XML::Rabbit;

has_xpath_value 'ref' => './@ref';

__PACKAGE__->meta->make_immutable();

1;
