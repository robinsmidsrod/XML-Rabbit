use strict;
use warnings;

package XML::Rabbit;
use 5.008;

# ABSTRACT: Consume XML with Moose and xpath queries

use XML::Rabbit::Sugar (); # no magic, just load
use namespace::autoclean (); # no cleanup, just load
use Moose::Exporter;

my ($import, $unimport, $init_meta) = Moose::Exporter->build_import_methods(
    also             => 'XML::Rabbit::Sugar',
    base_class_roles => ['XML::Rabbit::Node'],
);

=func import

Automatically loads L<namespace::autoclean> into the caller's package and
dispatches to L<XML::Rabbit::Sugar/"import"> (tail call).

=cut

sub import {
    namespace::autoclean->import( -cleanee => scalar caller );
    return unless $import;
    goto &$import;
}

=func unimport

Dispatches to L<XML::Rabbit::Sugar/"unimport"> (tail call).

=cut

sub unimport {
    return unless $unimport;
    goto &$unimport;
}

=func init_meta

Initializes the metaclass of the calling class and adds the role
L<XML::Rabbit::Node>.

=cut

#sub init_meta {
#    return unless $init_meta;
#    goto &$init_meta;
#}

# FIXME: https://rt.cpan.org/Ticket/Display.html?id=51561
# Hopefully fixed by 2.06 (doy)
sub init_meta {
    my ($dummy, %opts) = @_;
    Moose->init_meta(%opts);
    Moose::Util::MetaRole::apply_base_class_roles(
        for   => $opts{for_class},
        roles => ['XML::Rabbit::Node']
    );
    return Class::MOP::class_of($opts{for_class});
}

1;

=head1 SYNOPSIS

    my $xhtml = W3C::XHTML->new( file => 'index.xhtml' );
    print "Title: " . $xhtml->title . "\n";
    print "First image source: " . $xhtml->body->images->[0]->src . "\n";

    exit;

    package W3C::XHTML;
    use XML::Rabbit::Root;

    add_xpath_namespace 'xhtml' => 'http://www.w3.org/1999/xhtml';

    has_xpath_value 'title' => '/xhtml:html/xhtml:head/xhtml:title';

    has_xpath_object 'body',
        'W3C::XHTML::Body' => '/xhtml:html/xhtml:body',
    ;

    has_xpath_object_list 'all_anchors_and_images',
        {
            'xhtml:a'   => 'W3C::XHTML::Anchor',
            'xhtml:img' => 'W3C::XHTML::Image',
        },
        '//xhtml:a|//xhtml:img',
    ;

    finalize_class();

    package W3C::XHTML::Body;
    use XML::Rabbit;

    has_xpath_object_list 'images',
        'W3C::XHTML::Image' => './/xhtml:img',
    ;

    finalize_class();

    package W3C::XHTML::Image;
    use XML::Rabbit;

    has_xpath_value 'src'   => './@src';
    has_xpath_value 'alt'   => './@alt';
    has_xpath_value 'title' => './@title';

    finalize_class();

    package W3C::XHTML::Anchor;
    use XML::Rabbit;

    has_xpath_value 'href'  => './@src';
    has_xpath_value 'title' => './@title';

    finalize_class();


=head1 DESCRIPTION

XML::Rabbit is a Moose-based class construction toolkit you can use to make
XPath-based XML extractors with very little code.  Each attribute in your
class created with the above helper function is linked to an XPath query
that is executed on your XML document when you request the value.  Creating
object hierarchies that mimic the layout of the XML document is almost as
easy as doing a search and replace on the XML DTD (if you have one).

You can return multiple values from the XML either as arrays or hashes,
depending on how you need to work with the data from the XML document.

The example in the synopsis shows how to create a class hierarchy that
enables easy retrival of certain information from an XHTML document.

Also notice that if you specify an xpath query that can return multiple XML
elements, you need to specify a hash map (xml tag => class name) instead of
just specifying the class name returned.

All the array and hash-returning attributes are tagged with the Array and
Hash native traits, so it is quick and easy to specify additional
delegations.  All the C<has_xpath_value*> helpers expect the value to be of
a C<Str> type constraint.  Array and hash-returning attributes automatically
set their isa to C<ArrayRef[Str]> and C<HashRef[Str]> respectively.

All the helper methods and their associated arguments are explained in
L<XML::Rabbit::Sugar> detail.

Be aware that if your XML document contains a default XML namespace (like
XHTML does), you MUST specify it with C<add_xpath_namespace()>, or else your
xpath queries will not match anything.  The XML document is not scanned for
XML namespaces during initialization.


=head1 IMPORTS

When you specify C<use XML::Rabbit::Root> (or C<use XML::Rabbit> in child
nodes) you do the equivalent of the following code:

    use Moose;
    with "XML::Rabbit::RootNode"; # if you use XML::Rabbit::Root
    with "XML::Rabbit::Node";     # if you use XML::Rabbit
    use namespace::autoclean;
    use XML::Rabbit::Sugar;

This ensures that you don't have to specify C<no Moose> at the end of your
code to clean up imported functions you have used in your class.

The C<finalize_class()> call at the end of the file is the same as writing
the following piece of code:

    __PACKAGE__->meta->make_immutable();

    1;

This optimizes the class and ensures it always returns a true value, which
is required to successfully load a Perl script file.


=head1 TECHNICAL DETAILS

The trait applied to the attribute will wrap the type constraint union in an
ArrayRef if the trait name is XPathObjectList and as a HashRef if the trait
name is XPathObjectMap.  As all the traits that end with List return array
references, their C<isa> must be an ArrayRef.  The same is valid for the
*Map traits, just that they return HashRef instead of ArrayRef.

The namespace prefix used in C<isa_map> MUST be specified in the
C<namespace_map>. If a prefix is used in C<isa_map> without a corresponding
entry in C<namespace_map> an exception will be thrown.


=head1 CAVEATS

Be aware of the syntax of XPath when used with namespaces. You should almost
always define C<namespace_map> when dealing with XML that use namespaces.
Namespaces explicitly declared in the XML are usable with the prefix
specified in the XML (except if you use C<isa_map>). Be aware that a prefix
must usually be declared for the default namespace (xmlns=...) to be able to
use it in XPath queries. See the example above (on XHTML) for details. See
L<XML::LibXML::Node/findnodes> for more information.

Because XML::Rabbit uses XML::LibXML's DOM parser it is limited to handling
XML documents that can fit in available memory. Unfortunately there is no
easy way around this, because XPath queries need to work on a tree model,
and I am not aware of any way of doing that without keeping the document in
memory. Luckily XML::LibXML's DOM implementation is written in C, so it
should use much less memory than a pure Perl DOM parser.


=head1 SEMANTIC VERSIONING

This module uses semantic versioning concepts from L<http://semver.org/>.


=head1 ACKNOWLEDGEMENTS

The following people have helped to review or otherwise encourage
me to work on this module.

Chris Prather (perigrin)

Matt S. Trout (mst)

Stevan Little (stevan)


=head1 SEE ALSO

=for :list
* L<XML::Toolkit>
* L<Moose>
* L<XML::LibXML>
