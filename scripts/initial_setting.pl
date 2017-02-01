#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Std;
use Pod::Usage;
use Data::Dumper;
use File::Spec;
use File::Path qw(make_path);
use FindBin;
use Cwd qw(realpath getcwd);

my $VERSION = 0.01;

=pod

=head1 NAME

initial_setting.pl - setup environment. cf) vim, zsh, tmux ...

=head1 SYNOPSIS

  initial_setting.pl [options]

=head1 OPTIONS

=over 8

=item B<-c>

cleanup symlink

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

sub cf {
    return File::Spec->catfile( $FindBin::Bin, '..', @_ );
}

my %hash = (
    '.vim'              => cf(qw(vim)),
    '.vimrc'            => cf(qw(vim vimrc)),
    '.gemrc'            => cf(qw(gemrc)),
    '.gvimrc'           => cf(qw(vim gvimrc)),
    '.gitconfig'        => cf(qw(gitconfig)),
    '.zsh'              => cf(qw(zsh)),
    '.zshrc'            => cf(qw(zsh zshrc)),
    '.tmux.conf'        => cf(qw(tmux.conf)),
    '.screenrc'         => cf(qw(screen screenrc)),
    '.screen_setting'   => cf(qw(screen screen_setting.linux_utf8)),
    '.perltidyrc'       => cf(qw(perl perltidyrc_critic)),
    '.perlcriticrc'     => cf(qw(perl perlcriticrc)),
    '.replyrc'          => cf(qw(perl replyrc)),
    '.replyrc_vimshell' => cf(qw(perl replyrc_vimshell)),
);

main();

sub main {
    my $rh_args = &_init_args();
    if ( $rh_args->{c} ) {
        _cleanup_symlink();
        return;
    }
    _clone_submodules();
    _symlink_dot_files();
    _add_zshenv( $hash{'.zsh'} );
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
    chdir File::Spec->catfile( $FindBin::Bin, qw(..) );
    system 'git submodule init';
    system 'git submodule update';
    chdir $dir;
}

=item B<_mk_symlink> - make symbolic link

=cut

sub _mk_symlink {
    my ( $src, $target ) = @_;
    local $@;
    eval {
        symlink( $src, $target )
            or warn "fail to create symlink: ln -s $src $target";
    };
    if ($@) {
        die("fail to create symlink: ln -s $src $target\n$@");
    }
    return;
}

=item B<_symlink_dot_files> - make dot files symbolic link

=cut

sub _symlink_dot_files {
    while ( my ( $target, $src ) = each %hash ) {
        _mk_symlink( realpath($src),
            File::Spec->catfile( $ENV{HOME}, $target ) );
    }
}

=item B<_cleanup_symlink> - cleanup dot files symbolic link

=cut

sub _cleanup_symlink {
    while ( my ( $target, $src ) = each %hash ) {
        unlink File::Spec->catfile( $ENV{HOME}, $target );
    }
}

=item B<_init_args> - initialize arguments

		args(none)

		return value

			Success : hash reference of args (result of &_init_args)
			Failure : exit(show manual, show help and so on)

=cut

sub _init_args {
    my $args_pattern = 'chvm';

    my %args = ();
    if ( not getopts( $args_pattern, \%args ) ) { pod2usage(2); exit 0; }
    if ( exists $args{h} ) { pod2usage(1); exit 0; }
    elsif ( exists $args{m} ) {
        pod2usage( -exitstatus => 0, -verbose => 2 );
        exit 0;
    }
    elsif ( exists $args{v} ) { version(); exit 0; }
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

 Y.Watase <ywatase@gmail.com>

=cut

1;
