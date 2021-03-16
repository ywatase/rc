package {{_expr_:substitute(substitute(expand('%:r'), '.*lib[\\/]', '', 'g'), '[\\/]', '::', 'g')}};
use strict;
use warnings;
use Class::Tiny ();

our $VERSION = "0.01";

{{_cursor_}}

1;

__END__

=pod

=head1 NAME

{{_expr_:substitute(substitute(expand('%:r'), '.*lib[\\/]', '', 'g'), '[\\/]', '::', 'g')}} -

=head1 SYNOPSIS

  {{_expr_:substitute(substitute(expand('%:r'), '.*lib[\\/]', '', 'g'), '[\\/]', '::', 'g')}} -

=head1 DESCRIPTION

=head1 Method

=head2 new

=over 4

=item B<arg>

hoge

=back

=head1 PREREQUISITES

C<Class::Tiny>

=head1 Author

  {{_input_:author}} <{{_input_:email}}>

=cut
