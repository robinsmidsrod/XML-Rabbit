use strict;
use warnings;

package inc::MyMakeMaker;
use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_MakeFile_PL_template => sub {
    my ($self) = @_;
    my $template = super();
    my $exit_clause = "exit 0 if incompatible_libxml_version_found();\n\n";
    $template =~ s/^(WriteMakefile.*)$/$exit_clause$1/xmsg;
    $template .= <<'TEMPLATE';
sub incompatible_libxml_version_found {
    use XML::LibXML 1.70;
    my $v = XML::LibXML::LIBXML_RUNTIME_VERSION;
    return 1 if $v == 20616; # http://www.cpantesters.org/cpan/report/07429432-b19f-3f77-b713-d32bba55d77f
    return 0;
}
TEMPLATE
    return $template;
};

no Moose;
__PACKAGE__->meta->make_immutable();

1;
