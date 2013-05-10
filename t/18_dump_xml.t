#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;

my $res = WWW::LastFM::Response->new( file => 't/data/lastfm_metros.xml' );
lives_ok { $res->dump_document_xml } 'dump_document_xml() should not die on Unicode content';
lives_ok { $res->metros->dump_xml } 'dump_xml() should not die on Unicode content';

BEGIN {

    package WWW::LastFM::Response;
    use XML::Rabbit::Root;

    has_xpath_object 'metros' => '/lfm/metros' => 'WWW::LastFM::Response::MetroList';

    finalize_class();

    package WWW::LastFM::Response::MetroList;
    use XML::Rabbit;

    finalize_class();

}

1;
