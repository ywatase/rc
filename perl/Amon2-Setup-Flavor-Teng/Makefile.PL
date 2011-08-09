use inc::Module::Install;
name 'Amon2-Setup-Flavor-Teng';
all_from 'lib/Amon2/Setup/Flavor/Teng.pm';

build_requires 'Test::More';
auto_include;
WriteAll;
