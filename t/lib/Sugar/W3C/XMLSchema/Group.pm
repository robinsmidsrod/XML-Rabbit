use strict;
use warnings;

package Sugar::W3C::XMLSchema::Group;
use XML::Rabbit;

has_xpath_value 'ref' => './@ref';

has_xpath_object 'sequence',
    'Sugar::W3C::XMLSchema::Sequence' => './xsd:sequence',
;

finalize_class;
