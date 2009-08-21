package Rabbit::Parser;
use Moose;

use XML::LibXML ();

has '_parser' => (
    is         => 'ro',
    isa        => 'XML::LibXML',
    lazy_build => 1,
    reader     => 'parser',
);

sub _build__parser {
    my ($self) = @_;
    return XML::LibXML->new();
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;

=head1 NAME

Rabbit::Parser - Moose-based XML loader - parser base class


=head1 SYNOPSIS

    package MyXMLSyntax;
    use Moose;
    extends 'Rabbit::Parser';

    sub document {
        return shift->parser->parse_file( shift );
    }


=head1 DESCRIPTION

This module provides the base parser attribute used to parse the XML content.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<new>

Standard Moose constructor.


=item C<parser>

An instance of a L<XML::LibXML> parser. Read Only.


=item C<meta>

Moose meta object.


=back


=head1 BUGS

See L<Rabbit/BUGS>.


=head1 SUPPORT

See L<Rabbit/SUPPORT>.


=head1 AUTHOR

See L<Rabbit/AUTHOR>.


=head1 COPYRIGHT

See L<Rabbit/COPYRIGHT>.

=head1 LICENSE

See L<Rabbit/LICENSE>.


=cut
