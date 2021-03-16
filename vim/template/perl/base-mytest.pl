#/usr/bin/env perl
use strict;
use warnings;
use Test2::V0;

BEGIN{
    use_ok('{{_expr_:substitute(expand('%:r'), '[\\-]', '::', 'g')}}')
}

done_testing;
