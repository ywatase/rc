use inc::Module::Install;
name 'Test-Fixture-Teng';
all_from 'lib/Test/Fixture/Teng.pm';

build_requires 'Test::More';
auto_include;
WriteAll;
