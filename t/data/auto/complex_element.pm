package MyComplexElement;

use XML::Rabbit::Root;

add_xpath_namespace 'xsd' => 'http://www.w3.org/2001/XMLSchema';

has_xpath_value 'element_form_default' => './@elementFormDefault' => (
    xml_default => 'unqualified',
);

finalize_class;

'MyComplexElement';
