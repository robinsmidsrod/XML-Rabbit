package XML::Rabbit;

use 5.008;

use warnings;
use strict;
use utf8;

our $VERSION = '0.0.1';

=encoding utf8

=head1 NAME

XML::Rabbit - Moose-based XML loader

=head1 VERSION

Version 0.01


=head1 SYNOPSIS

    my $xhtml = W3C::XHTML->new( file => 'index.xhtml' );
    print "Title: " . $xhtml->title . "\n";
    print "First image source: " . $xhtml->body->images->[0]->src . "\n";

    exit;

    package W3C::XHTML;
    use Moose;
    with 'XML::Rabbit::RootNode';

    has '+namespace_map' => (
        default => sub { {
            "xhtml" => "http://www.w3.org/1999/xhtml"
        } },
    );

    has 'title' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => '/xhtml:html/xhtml:head/xhtml:title',
    );

    has 'body' => (
        isa         => 'W3C::XHTML::Body',
        traits      => [qw(XPathObject)],
        xpath_query => '/xhtml:html/xhtml:body',
    );

    has 'all_anchors_and_images' => (
        traits      => ['XPathObjectList'],
        xpath_query => '//xhtml:a|//xhtml:img',
        isa_map     => {
            'xhtml:a'   => 'W3C::XHTML::Anchor',
            'xhtml:img' => 'W3C::XHTML::Image',
        },
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package W3C::XHTML::Body;
    use Moose;
    with 'XML::Rabbit::Node';

    has 'images' => (
        isa         => 'ArrayRef[W3C::XHTML::Image]',
        traits      => [qw(XPathObjectList)],
        xpath_query => './/xhtml:img',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package W3C::XHTML::Image;
    use Moose;
    with 'XML::Rabbit::Node';

    has 'src' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@src',
    );

    has 'alt' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@alt',
    );

    has 'title' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package W3C::XHTML::Anchor;
    use Moose;
    with 'XML::Rabbit::Node';

    has 'href' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@src',
    );

    has 'title' => (
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;


=head1 DESCRIPTION

XML::Rabbit is a simple Moose-based base class you can use to make simple
XPath-based XML extractors. Each attribute in your class is linked to an
XPath query that is executed on your XML document when you request the
value.

Also notice that if you specify an xpath_query that can return multiple
types, you need to specify C<isa_map> instead of just specifying the types
as a union type constraint in C<isa>. If you specify C<isa_map> you should
not specify C<isa> aswell, as it will be overridden by the trait. The trait
will wrap the type constraint union in an ArrayRef if the trait name is
XPathObjectList. As all the traits that end with List return array
references, their C<isa> must be an ArrayRef.

The namespace prefix used in C<isa_map> MUST be specified in the
C<namespace_map>. If a prefix is used in C<isa_map> without a corresponding
entry in C<namespace_map> an exception will be thrown.


=head1 CAVEATS

Be aware of the syntax of XPath when used with namespaces. You should almost
always define C<namespace_map> when dealing with XML that use namespaces.
Namespaces explicitly declared in the XML are usable with the prefix
specified in the XML (except if you use C<isa_map>). See
L<XML::LibXML::Node/findnodes> for more information.


=head1 BUGS

Please report any bugs or feature requests to C<bug-xml-rabbit at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=XML-Rabbit>.  I will be
notified, and then you'll automatically be notified of progress on your bug
as I make changes.


=head1 AVAILABILITY

The latest version of this module can be downloaded from
http://github.com/robinsmidsrod/XML-Rabbit/


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc XML::Rabbit


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=XML-Rabbit>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/XML-Rabbit>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/XML-Rabbit>

=item * Search CPAN

L<http://search.cpan.org/dist/XML-Rabbit/>

=back


=head1 ACKNOWLEDGEMENTS

The following people have helped to review or otherwise encourage
me to work on this module.

Chris Prather (perigrin)

Matt S. Trout (mst)

Stevan Little (stevan)


=head1 AUTHOR

Robin Smidsrød, C<< <robin at smidsrod.no> >>


=head1 COPYRIGHT

Copyright 2009 Robin Smidsrød.


=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://dev.perl.org/licenses/ for more information.


=head1 SEE ALSO

L<XML::Toolkit>, L<Moose>, L<XML::LibXML>


=cut

1; # End of XML::Rabbit
