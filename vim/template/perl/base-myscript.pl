#!/usr/bin/env perl
use strict;
use warnings;

use Pod::Usage;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat bundling auto_version);

our $VERSION = "0.01";

my %args;

main();

sub main {
    init() or return 0;
}

sub init {
    my @args_pattern = ( 'file|f=s', 'help|h', 'manual', 'verbose' );

    %args = (
        # argname => 'default value'
    );
    if ( not GetOptions ( \%args, @args_pattern )) {pod2usage(2)}
    if (exists $args{help}) { pod2usage(-exitstatus => 0, -verbose => 1) }
    elsif (exists $args{manual}) { pod2usage(-exitstatus => 0, -verbose => 2) }
    if (exists $args{file})
    {
        if (not -e $args{file})
        {
            print "Can't access file: $args{file}\n";
            return;
        }
    }
#  if (not @ARGV)
#  {
#    print "You must input args\n";
#    pod2usage(1);
#  }
    return \%args;
}

1;

__END__

=pod

=head1 NAME

{{_expr_:expand('%')}} - Skeleton of Perl Script

=head1 SYNOPSIS

  {{_expr_:expand('%')}} [options]

=head1 OPTIONS

=over 8

=item B<--file|-f> filename

set filename

=item B<--help|?>

show help

=item B<--verbose>

verbose mode

=item B<--manual>

show manual

=item B<--version>

show version

=back

=head1 DESCRIPTION

This is skelton of perl script.

=head1 PREREQUISITES

This script requires the C<Getopt::Long>, C<Pod::Usage>

=head1 Author

  {{_input_:author}} <{{_input_:email}}>

=cut
