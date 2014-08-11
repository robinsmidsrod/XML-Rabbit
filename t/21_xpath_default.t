#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Path::Class;
use Scalar::Util qw(blessed);

my @xmls = grep {/[.]xml$/} dir('t/data/auto')->children;

for my $xml (@xmls) {
    test_xml($xml);
}

done_testing;
exit;

sub test_xml {
    my ($xml_file) = @_;
    my $pm_file = $xml_file;
    $pm_file =~ s/[.]xml$/.pm/xms;
    my $tests_file = $xml_file;
    $tests_file =~ s/[.]xml$/.has/xms;

    my $module = require $pm_file;

    my $object = $module->new( file => "$xml_file" );
    isa_ok $object, $module;

    my @tests = file($tests_file)->slurp;

    for my $test (@tests) {
        chomp $test;
        local $TODO;
        if ($test =~ s/^[#]//xms) {
            $TODO = "Skipping test '$test' for $xml_file";
        }

        my ($search, $value) = split /\s+/, $test, 2;
        is eval { search($object, $search) }, $value, "\$schema->$search == $value"
            or note $@;
    }
}

sub search {
    my ($obj, $query) = @_;

    my ($next, $rest) = split /->/, $query, 2;

    my $next_obj
        = blessed $obj && $obj->can($next) ? $obj->$next()
        : ref $obj eq 'ARRAY'              ? $obj->[$next]
        : ref $obj eq 'HASH'               ? $obj->{$next}
        :                                    die "Can't get $query from $obj\n";

    return $rest ? search($next_obj, $rest) : $next_obj;
}
