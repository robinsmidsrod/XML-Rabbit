use strict;
use warnings;

package XML::Rabbit::Root;
use 5.008;

# ABSTRACT: Root class with sugar functions available

use XML::Rabbit::Sugar (); # no magic, just load
use namespace::autoclean (); # no cleanup, just load
use Moose::Exporter;

my ($import, $unimport, $init_meta) = Moose::Exporter->build_import_methods(
    also             => 'XML::Rabbit::Sugar',
    base_class_roles => ['XML::Rabbit::RootNode'],
);

# Automatically force namespace::autoclean onto caller
sub import {
    namespace::autoclean->import( -cleanee => scalar caller );
    goto &$import if $import;
}

sub unimport  { goto &$unimport  if $unimport;  }
#sub init_meta { goto &$init_meta if $init_meta; }

# FIXME: https://rt.cpan.org/Ticket/Display.html?id=51561
# Hopefully fixed by 2.06 (doy)
sub init_meta {
    my ($dummy, %opts) = @_;
    Moose->init_meta(%opts);
    Moose::Util::MetaRole::apply_base_class_roles(
        for   => $opts{for_class},
        roles => ['XML::Rabbit::RootNode']
    );
    return Class::MOP::class_of($opts{for_class});
}

1;
