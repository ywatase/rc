#!/usr/bin/env perl
# Last Modified: 2015/02/10.
# Author: Y.Watase <ywatase@gmail.com>

use strict;
use warnings;
use Getopt::Std;
use Pod::Usage;
use Data::Dumper;
use File::Spec;
use File::Path qw(make_path);
use FindBin;
use Cwd qw(realpath getcwd);

my $VERSION = 0.0;

=pod

=head1 NAME

Skel - Skeleton of Perl Script

=head1 SYNOPSIS

  skel.pl [options]

=head1 OPTIONS

=over 8

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
    '.vim'              => File::Spec->catfile($FindBin::Bin, qw(.. vim)),
    '.vimrc'            => File::Spec->catfile($FindBin::Bin, qw(.. vim vimrc)),
    '.gemrc'            => File::Spec->catfile($FindBin::Bin, qw(.. gemrc)),
    '.gvimrc'           => File::Spec->catfile($FindBin::Bin, qw(.. vim gvimrc)),
    '.gitconfig'        => File::Spec->catfile($FindBin::Bin, qw(.. gitconfig)),
    '.zsh'              => File::Spec->catfile($FindBin::Bin, qw(.. zsh)),
    '.zshrc'            => File::Spec->catfile($FindBin::Bin, qw(.. zsh zshrc)),
    '.tmux.conf'        => File::Spec->catfile($FindBin::Bin, qw(.. tmux.conf)),
    '.screenrc'         => File::Spec->catfile($FindBin::Bin, qw(.. screen screenrc)),
    '.screen_setting'   => File::Spec->catfile($FindBin::Bin, qw(.. screen screen_setting.linux_utf8)),
    '.perltidyrc'       => File::Spec->catfile($FindBin::Bin, qw(.. perl perltidyrc_critic)),
    '.perlcriticrc'     => File::Spec->catfile($FindBin::Bin, qw(.. perl perlcriticrc)),
    '.replyrc'          => File::Spec->catfile($FindBin::Bin, qw(.. perl replyrc)),
    '.replyrc_vimshell' => File::Spec->catfile($FindBin::Bin, qw(.. perl replyrc_vimshell)),
);

main();

sub main {
    my $rh_args = &_init_args();
    _clone_submodules();
    _symlink_dot_files();
    _add_zshenv($hash{'.zsh'});
#    _setup_autojump();
    _clone_neobundle();
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

=item B<_clone_neobundle> - clone neobundle

=cut

sub _clone_neobundle {
    my $dir = getcwd;
    system "mkdir $ENV{HOME}/.vim/bundle";
    chdir "$ENV{HOME}/.vim/bundle";

    system "git clone https://github.com/Shougo/neobundle.vim.git";
    chdir $dir
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

=item B<_symlink_dot_files> - make dot files symbolic link

=cut

sub _symlink_dot_files {
    while(my ($target, $src) = each %hash){
        _mk_symlink(realpath($src),File::Spec->catfile($ENV{HOME}, $target));
    }
}

=item B<_setup_autojump> - install autojump

=cut

sub _setup_autojump {
    my $dir = getcwd;
    chdir File::Spec->catfile($FindBin::Bin, qw(.. zsh autojump.git));
    system('./install.sh', '--local');
    make_path(File::Spec->catfile($ENV{HOME}, qw(.local share autojump)));
    chdir $dir;
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
	$args_pattern .= 'hvm';

	my %args = ();
	if ( not getopts($args_pattern, \%args)) {pod2usage(2); exit 0; }
	if (exists $args{h}) { pod2usage(1); exit 0; }
  elsif (exists $args{m}) { pod2usage(-exitstatus => 0, -verbose => 2); exit 0;}
  elsif (exists $args{v}) { version(); exit 0; }
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
