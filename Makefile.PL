use inc::Module::Install 0.91;

name     'Rabbit';
author   'Robin Smidsrød <robin@smidsrod.no>';
license  'perl';
all_from 'lib/Rabbit.pm';

requires 'Moose'                       => '0.88';
requires 'XML::LibXML'                 => '1.69';
requires 'MooseX::Role::Parameterized' => '0.12';
requires 'Encode'                      => '2.26';

test_requires   'utf8'          => '1.06';
test_requires   'Test::More'    => '0.88';

auto_install;

WriteAll;
