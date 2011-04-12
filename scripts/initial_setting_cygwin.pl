#!/usr/bin/perl 
# Last Modified: 2011/04/12.
# Author: Y.Watase <ywatase@gmail.com>

use strict;
use warnings;
use Getopt::Std;
use Pod::Usage;
use Data::Dumper;

use FindBin;
use File::Spec;
use File::Copy;
use Cwd qw(realpath);

use constant DEBUG_LEVEL_USUAL   => 0;
use constant DEBUG_LEVEL_MESSAGE => 1;
use constant DEBUG_LEVEL_VERBOSE => 2;
use constant DEBUG_LEVEL_PRETEND => 3;    # not run command

use constant TYPE_SYMLINK => 0;
use constant TYPE_COPY    => 1;

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
C<Getopt::Std>, C<Pod::Usage>, C<Data::Dumper>, C<File::Spec>, C<FindBin>

=cut

my %hash = (
    'ck.app.dll'      => {
        path    => File::Spec->catfile($FindBin::Bin, qw(.. ck ck.app.dll)),
        target  => '/bin/',
        type    => TYPE_COPY,
    },
    'ck.con.exe'      => {
        path    => File::Spec->catfile($FindBin::Bin, qw(.. ck ck.con.exe)),
        target  => '/bin/',
        type    => TYPE_COPY,
    },
    'ck.exe'          => {
        path    => File::Spec->catfile($FindBin::Bin, qw(.. ck ck.exe)),
        target  => '/bin/',
        type    => TYPE_COPY,
    },
    '.ck.config.js'   => { path => File::Spec->catfile($FindBin::Bin, qw(.. ck ck.config.js)), },
    '.vim'            => { path => File::Spec->catfile($FindBin::Bin, qw(.. vim)) },
    '.vimrc'          => { path => File::Spec->catfile($FindBin::Bin, qw(.. vim vimrc))},
    '.zshrc'          => { path => File::Spec->catfile($FindBin::Bin, qw(.. zsh zshrc))},
    '.zsh'            => { path => File::Spec->catfile($FindBin::Bin, qw(.. zsh))},
    '.screenrc'       => { path => File::Spec->catfile($FindBin::Bin, qw(.. screen screenrc))},
    '.screen_setting' => { path => File::Spec->catfile($FindBin::Bin, qw(.. screen screen_setting.linux_utf8))},
    '.perltidyrc'     => { path => File::Spec->catfile($FindBin::Bin, qw(.. perl perltidyrc_critic))},
    '.perlcritic'     => { path => File::Spec->catfile($FindBin::Bin, qw(.. perl perlcritic))},
);

main();

sub main {
    my $rh_args = &_init_args('f:');
    while(my ($key, $value) = each %hash){
        $value->{type}   = TYPE_SYMLINK if(not exists $value->{type});
        $value->{target} = $ENV{HOME}   if(not exists $value->{target});
        if($value->{type} == TYPE_COPY){
            _mk_copy($value->{path},File::Spec->catfile($value->{target},$key));
        }
        elsif($value->{type} == TYPE_SYMLINK){
            _mk_symlink(realpath($value->{path}),File::Spec->catfile($value->{target},$key));
        }

    }
}

#################################################
# inner method
#################################################

=pod

=head1 Inner Methods

=over 8

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

=item B<_mk_symlink> - make symbolic link

=cut

sub _mk_copy {
    my ($src, $target) = @_;
    local $@;
    eval{
        copy($src, $target) or warn "fail to create copy: cp $src $target";
    };
    if($@){
        die("fail to create copy: cp $src $target\n$@");
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
#  if (not @ARGV) 
#  {
#    print "You must input args\n";
#    pod2usage(1);
#    exit 1;
#  }
	return \%args;
}

=item B<_setup> - setup

		args(none)

		return value

			Success : 
			Failure : undef

=cut

sub _setup {
}

=item B<_debugMsg> - show message

		args($ra1,$sc1)

		  $ra1    : array reference of message
			$sc1		: DEBUG LEVEL

		return value

			Success : 1
			Failure : undef

=cut

sub _debugMsg {
	my ($ra_msg, $level) = @_;
	print join("\n", @$ra_msg), "\n" if ($DEBUG >= $level);
}

=item B<_errorMsg> - show error mesage and exit.

		args($sc1)

		  $ra1    : scaler of message

		return value

      exit anyway and exit code is 1

=cut

sub _errorMsg {
	my $msg = shift;
	print STDERR $msg, "\n";
	pod2usage(1);
	exit 1;
} ## end sub _errorMsg

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


