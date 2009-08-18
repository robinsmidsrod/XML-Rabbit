use inc::Module::Install;

name     'Rabbit';
all_from 'lib/Rabbit.pm';
author   'Robin Smidsrød <robin@smidsrod.no>';
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

