#!/usr/bin/env perl 
#===============================================================================
#Last Modified:  <+DATE+>
#===============================================================================
use strict;
use warnings;

use Pod::Usage;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat bundling auto_version);

our $VERSION = "0.01";

main();

sub main {
    my $rh_args = &_init_args('file|f=s');
}

sub _init_args {
    my @args_pattern = @_;
    push @args_pattern, ( 'help|h', 'manual', 'verbose' );

    my %args = (
        # argname => 'default value'
    );
    if ( not GetOptions ( \%args, @args_pattern )) {pod2usage(2); exit 0; }
    if (exists $args{help}) { pod2usage(1); exit 0; }
    elsif (exists $args{manual}) { pod2usage(-exitstatus => 0, -verbose => 2); exit 0;}
    if (exists $args{file})
    {
        if (not -e $args{file})
        {
            print "Can't access file: $args{file}\n";
            exit 1;
        }
    }
#  if (not @ARGV) 
#  {
#    print "You must input args\n";
#    pod2usage(1);
#    exit 1;
#  }
    return \%args;
}
  
1;

__END__

=pod

=head1 NAME

<+FILE NAME+> - Skeleton of Perl Script

=head1 SYNOPSIS

  <+FILE NAME+> [options]

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

 <+AUTHOR+> <<+EMAIL+>>
  
=cut
