use strict;
use warnings;

package XML::Rabbit::Root;
use 5.008;

# ABSTRACT: Root class with sugar functions available

use XML::Rabbit::Sugar ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    also             => 'XML::Rabbit::Sugar',
    base_class_roles => ['XML::Rabbit::RootNode'],
);

# FIXME: https://rt.cpan.org/Ticket/Display.html?id=51561
# Hopefully fixed by 2.06 (doy)
sub init_meta {
    shift;
    my (%opts) = @_;
    Moose->init_meta(%opts);
    Moose::Util::MetaRole::apply_base_class_roles(
        for   => $opts{for_class},
        roles => ['XML::Rabbit::RootNode']
    );
    return Class::MOP::class_of($opts{for_class});
}

1;
