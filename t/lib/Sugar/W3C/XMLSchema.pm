package Sugar::W3C::XMLSchema;
use XML::Rabbit::Root;

add_xpath_namespace 'xsd' => 'http://www.w3.org/2001/XMLSchema';

has_xpath_object_list 'groups' => './xsd:group' => 'Sugar::W3C::XMLSchema::Group';

finalize_class;
