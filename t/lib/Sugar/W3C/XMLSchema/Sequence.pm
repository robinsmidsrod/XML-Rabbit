package Sugar::W3C::XMLSchema::Sequence;
use XML::Rabbit;

has_xpath_object_list 'items' => './*' =>
    {
        'xsd:group'   => 'Sugar::W3C::XMLSchema::Group',
        'xsd:element' => 'Sugar::W3C::XMLSchema::Element',
    },
;

finalize_class;
