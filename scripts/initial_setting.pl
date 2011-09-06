#!/usr/bin/env perl 
# Last Modified: 2011/09/06.
# Author: Y.Watase <ywatase@gmail.com>

use strict;
use warnings;
use Getopt::Std;
use Pod::Usage;
use Data::Dumper;
use File::Spec;
use FindBin;
use Cwd qw(realpath getcwd);


use constant DEBUG_LEVEL_USUAL   => 0;
use constant DEBUG_LEVEL_MESSAGE => 1;
use constant DEBUG_LEVEL_VERBOSE => 2;
use constant DEBUG_LEVEL_PRETEND => 3;    # not run command

my $VERSION = 0.0;
my $DEBUG   = DEBUG_LEVEL_USUAL;

=pod

=head1 NAME

Skel - Skeleton of Perl Script

=head1 SYNOPSIS

  skel.pl [options]

=head1 OPTIONS

=over 8

=item B<-f> filename

set filename

=item B<-V>

verbose mode

=item B<-d>

debug mode. more verbose.

=item B<-D>

debug mode. In this mode, never run command. only 'login' and 'enable'.

=item B<-h>

show help

=item B<-m>

show manual

=item B<-v>

show version

=back

=head1 DESCRIPTION

This is skelton of perl script.

=head1 PREREQUISITES

This script requires the C<strict> module.  It also requires
C<Getopt::Std>, C<Pod::Usage>

=cut

my %hash = (
    '.vim'            => File::Spec->catfile($FindBin::Bin, qw(.. vim)),
    '.vimrc'          => File::Spec->catfile($FindBin::Bin, qw(.. vim vimrc)),
    '.zshrc'          => File::Spec->catfile($FindBin::Bin, qw(.. zsh zshrc)),
    '.zsh'            => File::Spec->catfile($FindBin::Bin, qw(.. zsh)),
    '.screenrc'       => File::Spec->catfile($FindBin::Bin, qw(.. screen screenrc)),
    '.screen_setting' => File::Spec->catfile($FindBin::Bin, qw(.. screen screen_setting.linux_utf8)),
    '.perltidyrc'     => File::Spec->catfile($FindBin::Bin, qw(.. perl perltidyrc_critic)),
    '.perlcritic'     => File::Spec->catfile($FindBin::Bin, qw(.. perl perlcritic)),
);

main();

sub main {
    my $rh_args = &_init_args('f:');
    while(my ($target, $src) = each %hash){
        _mk_symlink(realpath($src),File::Spec->catfile($ENV{HOME}, $target));
    }
    _add_zshenv($hash{'.zsh'});
    _clone_submodules();
}

#################################################
# inner method
#################################################

=pod

=head1 Inner Methods

=over 8


=item B<_add_zshenv> - add to zshenv

=cut

sub _add_zshenv {
    my $zsh = shift;
    my $str = <<END;
if [ -e $zsh/zshenv ] ; then
    source $zsh/zshenv
fi
END
    open my $fh, '>>', "$ENV{HOME}/.zshenv" or die $!;
    print $fh $str;
    close $fh;
}

=item B<_clone_submodules> - clone submodules

=cut

sub _clone_submodules {
    my $dir = getcwd;
    chdir File::Spec->catfile($FindBin::Bin, qw(..));
    system 'git submodule init';
    system 'git submodule update';
    chdir $dir;
}

=item B<_mk_symlink> - make symbolic link

=cut

sub _mk_symlink {
    my ($src, $target) = @_;
    local $@;
    eval{
        symlink($src, $target) or warn "fail to create symlink: ln -s $src $target";
    };
    if($@){
        die("fail to create symlink: ln -s $src $target\n$@");
    }
    return;
}


=item B<_init_args> - initialize arguments

		args($sc1)

		  $sc1    : scaler (arguments pattern for Getopt::getopts)


		return value

			Success : hash reference of args (result of &_init_args)
			Failure : exit(show manual, show help and so on)

=cut

sub _init_args {
	my $args_pattern = shift;
	$args_pattern .= 'hvmDdV';

	my %args = ();
	if ( not getopts($args_pattern, \%args)) {pod2usage(2); exit 0; }
	if (exists $args{h}) { pod2usage(1); exit 0; }
  elsif (exists $args{m}) { pod2usage(-exitstatus => 0, -verbose => 2); exit 0;}
  elsif (exists $args{v}) { version(); exit 0; }
	if (exists $args{D}) { $DEBUG = DEBUG_LEVEL_PRETEND}
	if (exists $args{d}) { $DEBUG = DEBUG_LEVEL_VERBOSE}
	if (exists $args{V}) { $DEBUG = DEBUG_LEVEL_MESSAGE}
  if (exists $args{f})
  {
    if (not -e $args{f})
    {
      print "Can't access file: $args{f}\n";
      exit 1;
    }
  }
	return \%args;
}

=item B<version> - show version

		args(none)

		return value

			Success : 1
			Failure : undef

=cut

sub version {
	print <<EOS;
VERSION: $VERSION
EOS
}

=back

=head1 Author

 Y.Watase <watase.yusuke@adways.net>
  
=cut
  
1;
