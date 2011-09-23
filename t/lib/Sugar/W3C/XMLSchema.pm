package Sugar::W3C::XMLSchema;
use XML::Rabbit::Root;

add_xpath_namespace 'xsd' => 'http://www.w3.org/2001/XMLSchema';

has_xpath_object_list 'groups',
    'Sugar::W3C::XMLSchema::Group' => './xsd:group',
;

finalize_class;
