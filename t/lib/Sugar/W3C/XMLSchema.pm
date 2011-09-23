package Sugar::W3C::XMLSchema;
use XML::Rabbit::Root;

has '+namespace_map' => (
    default => sub { {
        'xsd' => 'http://www.w3.org/2001/XMLSchema',
    } }
);

has_xpath_object_list 'groups',
    'Sugar::W3C::XMLSchema::Group' => './xsd:group',
;

finalize_class;
