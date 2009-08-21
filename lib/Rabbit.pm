package Rabbit;

use 5.008;

use warnings;
use strict;

use utf8;

our $VERSION = '0.01';

=head1 NAME

Rabbit - Moose-based XML loader

=head1 VERSION

Version 0.01


=head1 SYNOPSIS

    package MyXHTMLParser;
    use Moose;
    extends 'Rabbit::RootNode';

    has 'title' => (
        is          => 'ro',
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => '/html/head/title',
    );

    has 'body' => (
        is          => 'ro',
        isa         => 'MyXHTMLParser::Body',
        traits      => [qw(XPathObject)],
        xpath_query => '/html/body',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package MyXHTMLParser::Body;
    use Moose;
    extends 'Rabbit::Node';

    has 'images' => (
        is          => 'ro',
        isa         => 'ArrayRef[MyXHTMLParser::Image]',
        traits      => [qw(XPathObjectList)],
        xpath_query => './/img',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    package MyXHTMLParser::Image;
    use Moose;
    extends 'Rabbit::Node';

    has 'src' => (
        is          => 'ro',
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@src',
    );

    has 'alt' => (
        is          => 'ro',
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@alt',
    );

    has 'title' => (
        is          => 'ro',
        isa         => 'Str',
        traits      => [qw(XPathValue)],
        xpath_query => './@title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;


=head1 DESCRIPTION

Rabbit is a simple Moose-based base class you can use to make simple
XPath-based XML extractors. Each attribute in your class is linked to an
XPath query that is executed on your XML document when you request the
value.


=head1 BUGS

Please report any bugs or feature requests to C<bug-rabbit at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Rabbit>.  I will be
notified, and then you'll automatically be notified of progress on your bug
as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Rabbit


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Rabbit>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Rabbit>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Rabbit>

=item * Search CPAN

L<http://search.cpan.org/dist/Rabbit/>

=back


=head1 AUTHOR

Robin Smidsrød, C<< <robin at smidsrod.no> >>


=head1 COPYRIGHT

Copyright 2009 Robin Smidsrød.


=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Rabbit
